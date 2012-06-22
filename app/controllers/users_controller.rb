class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.where("avatar_file_name is not null").order("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end

  # POST /users/post_update/1
  def post_update

    @user = User.find_by_facebook_id(params[:id])
    newFile = File.new("#{params[:id]}.png", 'wb')
    newFile.write(Base64.decode64(params[:avatar]))

    params[:user] = {}
    params[:user][:avatar] = newFile

    respond_to do |format|
      if @user.update_attributes(params[:user])
  
        # USER
        @user[:short_url] = "hola"
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render json: @user }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
      File.delete("#{params[:id]}.png")
    end

  end

  def find_or_create_fan
    @user = User.find_or_create_fan(params[:id], params[:is_fan], params[:voting_app], params[:email])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user, :include => [:referrals] }
    end
  end

  def add_activity
    @user = User.add_activity(params[:id], params[:activity_id])
		if @user[:voted]
			if session[:oauth_tokens]
				@user.post_to_twitter(session[:oauth_tokens], Activity.find(params[:activity_id]).candidato)
			end
		end
    respond_to do |format|
      format.json { render json: @user }
    end
  end

  def send_email

    @user = User.find_by_facebook_id(params[:id])
    UserMailer.send_identification(@user, params[:email]).deliver
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  def redirect
    @params = params
    #redirect_to("/php1/index.php?signed_request=#{params[:signed_request]}")
  end

end
