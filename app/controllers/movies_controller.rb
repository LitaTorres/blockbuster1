class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]

  # GET /movies or /movies.json
  def index
    @movies = Movie.all
  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to movie_url(@movie), notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update #validación para que las personas solo arrienden 1 vez
    if movie_params['customer_id'] == "1" # si movie params es = a 1 (1es el videoclub) no le aplica la validación 
      respond_to do |format| #y se hace todo normal esto
        if @movie.update(movie_params)
          format.html { redirect_to movie_url(@movie), notice: "Movie was successfully updated." }
          format.json { render :show, status: :ok, location: @movie }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @movie.errors, status: :unprocessable_entity }
        end
     end  
    else
    #si el cliente tiene mas de 0 dará un error xq ya tiene arriendos
      if Customer.find(movie_params['customer_id']).movies.count > 0 #si es mayo a 0 es xq ya tiene 1 peli arrendada
        respond_to do |format| #y se hace todo normal esto
            format.html { redirect_to movies_path, notice: "#{Customer.find(movie_params['customer_id']).name} Ya tienes 1 película arrendada"}
          end
      else
        respond_to do |format| #y se hace todo normal esto
          if @movie.update(movie_params)
            format.html { redirect_to movie_url(@movie), notice: "Movie was successfully updated." }
            format.json { render :show, status: :ok, location: @movie }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @movie.errors, status: :unprocessable_entity }
          end
        end
     end
  end
end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to movies_url, notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:title, :customer_id)
    end
end
