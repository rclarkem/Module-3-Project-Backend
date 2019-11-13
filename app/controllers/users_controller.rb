class UsersController < ApplicationController
  def index
    render json: User.all
  end

  def create
    user = User.find_by(username: user_params[:username])
    if !user 
      user = User.create(user_params)  
    end
    render json: user 
  end

  def show
    user = User.find(params[:id])
    if user 
      if params[:federal] == 'true'
        google_civic_reps = RepresentativeService.get_federal_representatives(user.address)
        final_reps = google_civic_reps.map do |rep|
          user.representatives << rep
          names = rep["name"].split(' ') 
          our_rep = nil
          if names.count == 3
            our_rep = Representative.find_by(first_name: names[0], last_name: names[2], middle_name: names[1])
          else
            our_rep = Representative.find_by(first_name: names[0], last_name: names[1])
          end
          if our_rep
            rep = rep.merge({proPublica_id: our_rep['proPublica_id']})
          end
          rep
        end
        render json: final_reps
      else
        final_reps = RepresentativeService.get_local_representatives(user.address)
        render json: final_reps
      end
    end
  end

  private 
  def user_params
    params.require(:user).permit(:username, :address)
  end
end