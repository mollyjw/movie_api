class Api::V1::MoviesController < ApplicationController
    before_action :set_movie, only: [:show, :update, :destory]
    skip_before action :authenticate, only: [:index, :show]
    #GET /movies
    def index
        @movies = Movie.all
        render json: @movies
    end

    #GET /movies/1
    def show
        @reviews = Review.where(movie_id: params[:id])
        render json: { movie: @movie, reviews: @reviews }
    end

    #POST /movies
    def create
        @movie = Movie.new(movie_params)
        if @movie.save
            render json: @movie
        else
            render json: @movie.errors, status: unprocessable_entity
        end
    end

    #PATCH/PUT /movies/1
    def update
        if @movie.update(movie_params)
            render json: @movie
        else
            render json: @movie.errors, status: unprocessable_entity
        end
    end

    #DELETE /movies/1
    def destory
        @movie.destory
    end

    # Get our Amazon S3 Keys for image uploads
    def get_upload_credentials
        @accesskey = ENV['S3_ACCESS']
        @secretkey = ENV['S3_SECRET']
        render json: ( accesskey: @accesskey, secretkey: @secretkey)
    end

    private
    #Methods we place under private can only be accessed by other methods on our movies controller

    def set_movie
        @Movie = Movie.find(params[:id])
    end

    def movie_params
        params.require(:movie).permit( :title, :description, :parental_rating, :year, :total_gross, :duration, :image, :cast, :director)
    end


end
