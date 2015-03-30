class ChallengesController < ApplicationController
  before_action :set_challenge, only: [:show, :edit, :update, :destroy]

  # GET /challenges
  # GET /challenges.json
  def index
    @challenges = Challenge.all
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

    user_code = params[:tabs][0]["starter_code"]

    result = false
    message = ""

    @steps.each do |step|
      puts step.step_text
      puts params[:tabs][0]["starter_code"]
      hcm = HtmlCssMatcher.new(step.step_text, user_code)

      result, message = hcm.run

      break if (!result)
    end

    respond_to do |format|
      if (result)
        user_solution = UserSolution.where(user_id: current_user.id, challenge_id: @challenge.id).first
        message = ""
        if (user_solution)
          message = "#{t('challenges.your_answer_is_correct')}, #{t('challenges.you_already_did_it')}"
        else
          UserSolution.create!(
            code: user_code,
            points: @challenge.points,
            user: current_user, challenge: @challenge
          )
          message = "#{t('challenges.your_answer_is_correct')}, #{t('challenges.you_earned_points', points_no: @challenge.points)}"
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
