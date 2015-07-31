class RegistrationsController < Devise::RegistrationsController

  skip_before_action :check_info, :only => [:student_sign_up, :professor_sign_up]
  before_filter :configure_permitted_parameters

  def new
    redirect_to root_path
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      if @user.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(:user, @user)
        respond_with @user, :location => after_sign_up_path_for(@user)
      else
        set_flash_message :notice, :"signed_up_but_#{@user.inactive_message}" if is_navigational_format?
        expire_data_after_sign_in!
        respond_with @user, :location => after_inactive_sign_up_path_for(@user)
      end
    else
      clean_up_passwords @user
      if @user.errors.full_messages.include? "Email has already been taken"
        flash[:alert] = %Q[Email already in use. <a href="/users/password/new">Forgot Your Password?</a>].html_safe
      end
      redirect_to root_path
    end
  end

  def edit
    @student = current_user.student
    @majors_list = Major.all.order(:name).map{|m| [m.name, m.id]}
    @major_ids = @student.majors.pluck(:id)
    super
  end

  def update
    @user = current_user
    @student = @user.student
    @majors_list = Major.all.order(:name).map{|m| [m.name, m.id]}
    @major_ids = @student.majors.pluck(:id)

    if @user.valid_password?(params[:user][:current_password])

      @student.grad_year = params[:student][:grad_year]

      if (m_id = params[:major1].to_i) != (@student.majors[0] ? @student.majors[0].id : nil)

        curr_maj_1 = (@student.majors[0] == nil ? false : true)

        if curr_maj_1
          s = StudentMajor.find_by(:student_id => @student.id, :major_id => @student.majors[0].id)
        else
          s = StudentMajor.new(:student_id => @student.id)
        end

        if s != nil
          if m_id == 0
            s.destroy
          else
            s.major_id = m_id
            s.save
          end
        else
          if m_id != 0
            @student.majors.push(Major.find(m_id));
          end
        end
      end

      if (m_id = params[:major2].to_i) != (@student.majors[1] ? @student.majors[1].id : 0)

        curr_maj_2 = (@student.majors[1] == nil ? false : true)

        if curr_maj_2
          s = StudentMajor.find_by(:student_id => @student.id, :major_id => @student.majors[1].id)
        else
          s = StudentMajor.new(:student_id => @student.id)
        end

        if s != nil
          if m_id == 0
            s.destroy
          else
            s.major_id = m_id
            s.save
          end
        else
          if m_id != 0
            @student.majors.push(Major.find(m_id));
          end
        end
      end

      if (m_id = params[:major3].to_i) != (@student.majors[2] ? @student.majors[2].id : 0)

        curr_maj_3 = (@student.majors[2] == nil ? false : true)

        if curr_maj_3
          s = StudentMajor.find_by(:student_id => @student.id, :major_id => @student.majors[2].id)
        else
          s = StudentMajor.new(:student_id => @student.id)
        end

        if s != nil
          if m_id == 0
            s.destroy
          else
            s.major_id = m_id
            s.save
          end
        else
          if m_id != 0
            @student.majors.push(Major.find(m_id));
          end
        end
      end

      @student.save
    end

    super
  end

  def student_sign_up
    @user = current_user
    if @user == nil || (@user.student != nil || @user.professor != nil)
      redirect_to browse_path
    end
    @student = Student.new
    @majors_list = Major.all.order(:name).map{|m| [m.name, m.id]}
  end

  def professor_sign_up
    @user = current_user
    if @user == nil || (@user.student != nil || @user.professor != nil)
      redirect_to browse_path
    end
    @prof_user = ProfessorUser.new
  end

  private 

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :remember_me, 
        :first_name, :last_name)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update).push(:first_name, :last_name)
  end
end
