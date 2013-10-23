class RegistrationsController < Devise::RegistrationsController

  skip_before_action :check_info, :only => [:student_sign_up, :professor_sign_up]

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
        expire_session_data_after_sign_in!
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

      if (m_id = params[:major1].to_i) != (@student.majors[0] ? @student.majors[0].id : nil)

        s = StudentMajor.find_by(:student_id => @student.id, :major_id => @student.majors[0].id)

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

      if (m_id = params[:major2].to_i) != (@student.majors[1] ? @student.majors[1].id : nil)

        s = StudentMajor.find_by(:student_id => @student.id, :major_id => @student.majors[1].id)

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

      if (m_id = params[:major3].to_i) != (@student.majors[2] ? @student.majors[2].id : nil)

        s = StudentMajor.find_by(:student_id => @student.id, :major_id => @student.majors[2].id)

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

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :remember_me, 
        :first_name, :last_name)
  end

end
