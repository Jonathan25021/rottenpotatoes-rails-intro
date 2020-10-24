class MoviesController < ApplicationController
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    puts params
    if params["home"] == "1"
      session_hash = session["a"]
      puts "incomming session hash"
      puts session_hash
      @ratings_to_show = session_hash["ratings"]
      @sort_val = session_hash["refresh"]
      puts "sort from session"
      puts @sort_val
    else
      ratings_list = params[:ratings]
      @sort_val = params[:refresh]
      if ratings_list == nil
        ratings_list = Hash[]
      end
      puts "ratings list"
      puts ratings_list
      @ratings_to_show = ratings_list.keys
    end
    @all_ratings = Movie.all_ratings
    
    puts @ratings_to_show
    @movies = Movie.with_ratings(@ratings_to_show)
    @ratings_hash = Hash[@ratings_to_show.collect { |rating| [rating, 1] } ]
    if @sort_val == "title"
      @title_sort = true
      @release_date_sort = false
      @movies = Movie.sort_by_title(@ratings_to_show)
    end
    if @sort_val == "release_date"
      @title_sort = false
      @release_date_sort = true
      @movies = Movie.sort_by_release_date(@ratings_to_show)
    end
    session_hash = {:ratings => @ratings_to_show, :refresh => @sort_val}
    session[:a] = session_hash
    puts "session hash at end"
    puts session[:a]
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
