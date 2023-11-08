class LeavesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_leafe, only: %i[ show edit update destroy ]

  # GET /leaves or /leaves.json
 def index
  
  @user = current_user 
  
  if current_user.HR?
     @leaves = Leafe.where(status: 'pending')

  elsif current_user.manager?
      # debugger
 
    manager_leave = Leafe.where(user_id: current_user.subordinates.pluck(:id), status: 'pending')
    ids = current_user.subordinates.pluck(:team_lead_id, :id).flatten.compact.uniq
    team_members = User.where(team_lead_id: ids)
    team_members_leaves = Leafe.where(user_id: team_members.pluck(:id), status: 'pending')
    @leaves = manager_leave + team_members_leaves
    
  elsif current_user.team_lead?
    team = current_user.team_members
    @leaves = Leafe.where(user_id: team.pluck(:id)).where(status: 'pending')
  else
    
  end
end

   def leave_details
    @user = current_user
    @leaves = current_user.leaves
   end

  # GET /leaves/1 or /leaves/1.json
  def show

  end

  # GET /leaves/new
  def new
    @leafe = Leafe.new
  end

  # GET /leaves/1/edit
  def edit
  end

  # POST /leaves or /leaves.json
  def create

    
    @leafe = current_user.leaves.new(leafe_params)

    respond_to do |format|
      if @leafe.save
        format.html { redirect_to leafe_url(@leafe), notice: "Leafe was successfully created." }
        format.json { render :show, status: :created, location: @leafe }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @leafe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leaves/1 or /leaves/1.json
  def update
    respond_to do |format|
      if @leafe.update(leafe_params)
        format.html { redirect_to leafe_url(@leafe), notice: "Leafe was successfully updated." }
        format.json { render :show, status: :ok, location: @leafe }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @leafe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leaves/1 or /leaves/1.json
  def destroy
    @leafe.destroy!

    respond_to do |format|
      format.html { redirect_to leaves_url, notice: "Leafe was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  
def approve
   
    @leafe = Leafe.find_by(id:params[:id])
    @leafe.update(status: 1)
    
    UserMailer.leave_approval_email(@leafe.user, @leafe).deliver_now
    
    respond_to do |format|
      format.html { redirect_to approve_leafe_url, notice: "Leafe was approved." }
      format.json { head :no_content }
    end
  end

  def reject
    @leafe = Leafe.find_by(id:params[:id])
    @leafe.update(status: 2)
    UserMailer.leave_rejection_email(@leafe.user, @leafe).deliver_now
    respond_to do |format|
      format.html { redirect_to reject_leafe_url, notice: "Leafe was rejected" }
      format.json { head :no_content }
    end
  end

  def update_status
  @leafe = Leafe.find_by(id: params[:id])
  status = params[:status].to_i

  if status.in?([1, 2])
    @leafe.update(status: status)

    if status == 1
      UserMailer.leave_approval_email(@leafe.user, @leafe).deliver_now
      redirect_url = approve_leafe_url
      notice_message = "Leafe was approved."
    else
      UserMailer.leave_rejection_email(@leafe.user, @leafe).deliver_now
      redirect_url = reject_leafe_url
      notice_message = "Leafe was rejected."
    end

    respond_to do |format|
      format.html { redirect_to redirect_url, notice: notice_message }
      format.json { head :no_content }
    end
  else
    respond_to do |format|
      format.html { redirect_to root_url, alert: "Invalid status." }
      format.json { head :bad_request }
    end
  end
end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leafe
      @leafe = Leafe.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def leafe_params
      params.require(:leafe).permit(:status, :reason, :from_date, :to_date, :leave_type)
    end
end
