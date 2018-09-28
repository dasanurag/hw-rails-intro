class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    goback = 0
    
	#capture the ratings and sort info and push it to session hash if any
	#use the sort and rating info to capture the respective movies and sort them after redirect  
    if params[:sort]
    	@selected_sort = params[:sort]
    	session[:sort] = @selected_sort
    elsif session[:sort]
    	@selected_sort = session[:sort]
    	goback = 1
    else
    	@selected_sort = nil	
    end
    	    	      
    if params[:ratings]
    	@selected_ratings = params[:ratings]
    	session[:ratings] = @selected_ratings
    elsif session[:ratings]
    	@selected_ratings = session[:ratings]
    	goback = 1
    else
    	@selected_ratings = nil
    end

	if goback == 1		
		redirect_to movies_path(:sort => @selected_sort,:ratings => @selected_ratings)
	end

	
	if @selected_ratings and @selected_sort
		@movies = Movie.where(:rating => @selected_ratings.keys).order(@selected_sort) 
	elsif @selected_ratings
		@selected_movies = Movie.where(:rating => @selected_ratings.keys)
	elsif @selected_sort
		@movies = Movie.order(@selected_sort)
	else
		@movies = Movie.all
	end				
    
    #if selected ratings is nil, set it to a new hash to avoid nil ratings error
    if @selected_ratings == nil
		@selected_ratings = Hash.new
	end

    #sort the movies 
    #select the movies according to ratings 			
    #@movies = Movie.order(params[:sort])	  	
	#if params[:ratings]		
	#	@movies = Movie.where(:rating => params[:ratings].keys).sort
	#end  
	#@ratings = session[:ratings]
	
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

end
