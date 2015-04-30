class ChallengesController < ApplicationController
  before_action :set_challenge, only: [:show, :edit, :update, :destroy]

  # GET /challenges
  # GET /challenges.json
  def index
    @chapter = Chapter.find(params[:chapter_id])
    @challenges = @chapter.challenges
  end

  # GET /challenges/1
  # GET /challenges/1.json
  def show
  end

  # GET /challenges/new
  def new
    @challenge = Challenge.new
  end

  # GET /challenges/1/edit
  def edit
  end

  # POST /challenges
  # POST /challenges.json
  def create
    @challenge = Challenge.new(challenge_params)

    respond_to do |format|
      if @challenge.save
        format.html { redirect_to @challenge, notice: 'Challenge was successfully created.' }
        format.json { render :show, status: :created, location: @challenge }
      else
        format.html { render :new }
        format.json { render json: @challenge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /challenges/1
  # PATCH/PUT /challenges/1.json
  def update
    respond_to do |format|
      if @challenge.update(challenge_params)
        format.html { redirect_to @challenge, notice: 'Challenge was successfully updated.' }
        format.json { render :show, status: :ok, location: @challenge }
      else
        format.html { render :edit }
        format.json { render json: @challenge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /challenges/1
  # DELETE /challenges/1.json
  def destroy
    @challenge.destroy
    respond_to do |format|
      format.html { redirect_to challenges_url, notice: 'Challenge was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def check_validation
    @chapter = Chapter.where(id: params[:chapter_id].to_i).eager_load(:badges, challenges: [:challenge_steps]).order('challenges.id').first
    @challenges = @chapter.challenges
    @challenge = @challenges.find_all { |challenge| challenge.id == params[:challenge_id].to_i }.first
    @steps = @challenge.challenge_steps


    user_code = params[:tabs].select { |tab| tab[:language_name] == "html" }[0]["starter_code"]
    styles = params["challenge"]["styles"]

    result = false
    message = ""

    @steps.each do |step|
      hcm = HtmlCssMatcher.new(step.step_text, user_code, styles)#[{ "h2" => [ {"color" => "rgb(255, 0, 0)"} ] }])

      result, message = hcm.run

      break if (!result)
    end


    respond_to do |format|
      if (user_signed_in?)
        if (result)
          user_solution = UserSolution.where(user_id: current_user.id, challenge_id: @challenge.id).first
          message = ""
          if (user_solution)
            message = "#{t('challenges.your_answer_is_correct')}, #{t('challenges.you_already_did_it')}"
          else
            hints_point = current_user.hints.where('hints.challenge_id = ?', @challenge.id).sum(:points)
            new_points = @challenge.points - hints_point

            user_solution = UserSolution.new(
              points: new_points,
              user: current_user, challenge: @challenge
            )

            tabs = params[:tabs]
            tabs.each do |tab|
              user_solution.user_solution_tabs << UserSolutionTab.new(
                code: tab["starter_code"],
                name: tab["name"],
                language_name: tab["language_name"]
              )
            end

            if (user_solution.save)
              message = "#{t('challenges.your_answer_is_correct')}, #{t('challenges.you_earned_points', points_no: new_points)}"
            else
              message = "#{t('challenges.your_answer_does_not_saved')}"
            end
          end

          if (@challenges.last.id == @challenge.id)
            user_solutions = UserSolution.where('user_id = ? AND challenge_id IN (?)',
              current_user.id,
              @challenges.map { |challenge| challenge.id }
            )

            user_points = user_solutions.sum(:points)
            badges = current_user.badges
            chapter_badges = @chapter.badges.where('points <= ?', user_points)
            new_badges = []

            chapter_badges.each do |badge|
              if (!badges.include?(badge))
                new_badges << badge
              end
            end

            current_user.badges << new_badges

            next_chapter = @chapter.next
            format.json { render json: {
                success: true,
                message: message,
                next_chapter_id: next_chapter ? next_chapter.id : nil
              }
            }
          else
            format.json { render json: {
                success: true,
                message: message,
                next_chapter_id: 0
              }
            }
          end
        else
          format.json { render json: {success: false, message: message} }
        end
      else
        if (result)
          message = "#{t('challenges.your_answer_is_correct')}, #{t('challenges.you_are_not_signed_in')}"

          next_chapter = @chapter.next
          format.json { render json: {
              success: true,
              message: message,
              next_chapter_id: next_chapter ? next_chapter.id : nil
            }
          }
        else
          format.json { render json: {success: false, message: message} }
        end
      end
    end
  end

  def get_hint
    @hint = Hint.find(params[:hint_id])

    if (@hint)
      if (!current_user.hints.include?(@hint))
        current_user.hints << @hint
      end
      respond_to do |format|
        format.json { render json: @hint }
      end
    end
  end

  def get_next_hint
    @hint = Hint.where('challenge_id = ? AND id > ?', params[:challenge_id].to_i, params[:hint_id].to_i).first

    respond_to do |format|
      if (@hint)
        if (!current_user.hints.include?(@hint))
          current_user.hints << @hint
        end
        format.json { render json: @hint }
      else
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_challenge
      @challenge = Challenge.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def challenge_params
      params.require(:challenge).permit(:name, :desc, :chapter_id)
    end
end
