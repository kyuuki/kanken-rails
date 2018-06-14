class Admin::AppsController < Admin::ApplicationController
  def index
    @apps = App.order(:id)
  end

  def show
  end

  def new
    @app = App.new
    @app.build_app_twitter_setting
  end

  def edit
    @app = App.find(params[:id])
  end

  def create
    @app = App.new(app_params)

    respond_to do |format|
      if @app.save
        format.html { redirect_to admin_apps_url, notice: 'App was successfully created.' }
        format.json { render :show, status: :created, location: @app }
      else
        format.html { render :new }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @app = App.find(params[:id])

    respond_to do |format|
      if @app.update(app_params)
        format.html { redirect_to admin_apps_url, notice: 'App was successfully updated.' }
        format.json { render :show, status: :ok, location: @app }
      else
        format.html { render :edit }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @app = App.find(params[:id])

    @app.destroy
    respond_to do |format|
      format.html { redirect_to admin_apps_url, notice: 'App was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def app_params
      params.require(:app).permit(:name, :identifier, :url,
                                  app_twitter_setting_attributes: [:id,
                                                                   :consumer_key,
                                                                   :consumer_secret,
                                                                   :access_token,
                                                                   :access_token_secret,
                                                                   :message])
    end
end
