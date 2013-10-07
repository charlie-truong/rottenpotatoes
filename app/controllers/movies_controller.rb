class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    @selected_ratings = @all_ratings
    @highlight_title = ''
    @highlight_release_date = ''

    if params[:ratings]
      @selected_ratings = params[:ratings].keys
      session[:ratings] = params[:ratings].keys
    elsif session[:ratings]
      @selected_ratings = session[:ratings]
    end

    if params[:sort] == 'movie_title'
      @movies = Movie.where("rating IN (?)", @selected_ratings).order('title ASC')
      @highlight_title = 'hilite'
      session[:sort] = 'movie_title'
    elsif params[:sort] == 'release_date'
      @movies = Movie.where("rating IN (?)", @selected_ratings).order('release_date ASC')
      @highlight_release_date = 'hilite'
      session[:sort] = 'release_date'
    elsif session[:sort] == 'movie_title'
      @movies = Movie.where("rating IN (?)", @selected_ratings).order('title ASC')
      @highlight_title = 'hilite'
    elsif session[:sort] == 'release_date'
      @movies = Movie.where("rating IN (?)", @selected_ratings).order('release_date ASC')
      @highlight_release_date = 'hilite'
    else
      @movies = Movie.where("rating IN (?)", @selected_ratings)
    end

    session[:return_url] = request.original_url
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
