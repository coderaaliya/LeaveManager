class EmployeesController < ApplicationController
  before_action :authenticate_user!

  before_action :set_employee, only: [:edit, :update]
  def index
    @employee= current_user
    @employees = @employee ? [@employee] : []
  end
  def edit
     @employee = Employee.find(params[:id])
  end
  def show
    @employee = Employee.find(params[:id])
  end
  def update
    if @employee.update(employee_params)
      redirect_to @employee, notice: 'Employee details were successfully updated.'
    else
      render :edit
    end
  end


  private

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(
      :position,:employment_id,
      user_attributes: [:email, :first_name, :last_name, :location, :role, :Total_leaves_allowed, :id]
      )

  end
end
