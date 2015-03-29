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
    @challenge = Challenge.find(params[:challenge_id])
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
        user_solution = UserSolution.where(user_id: current_user.id, challenge_id: @challenge.id)
        if (user_solution)
          format.json { render json: {success: true, message: "#{t('challenges.your_answer_is_correct')}, #{t('challenges.you_already_did_it')}"} }
        else
          UserSolution.create!(
            code: user_code,
            points: @challenge.points,
            user: current_user, challenge: @challenge
          )
          format.json { render json: {success: true, message: "#{t('challenges.your_answer_is_correct')}, #{t('challenges.you_earned_points', points_no: @challenge.points)}"} }
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
