class ImportCommentsController < ApplicationController
  def index
    render 'import_comments'
  end

  # Método para submeter notas em massa para vários filmes
  def import_grades
    file = params[:file]

    if file.present? && file.respond_to?(:tempfile)
      errors = []

      CSV.foreach(file.tempfile, headers: true) do |row|
        begin
          movie_title = row['movie_title']
          director = row['director']
          score = row['score']

          # Encontre o filme pelo Título e Diretor
          movie = Movie.find_by(title: movie_title, director: director)

          if movie.present?
            user_id = session[:user_id]  # Obtém o ID do usuário da sessão atual

            # Verifica se o usuário já deixou um comentário para o filme
            user_movie = UserMovie.find_by(user_id: user_id, movie_id: movie.id)

            if user_movie.nil?
              # Se o usuário ainda não tiver deixado um comentário para o filme, insira um novo comentário
              UserMovie.create(user_id: user_id, movie_id: movie.id, score: score)
            else
              # Caso contrário, atualize o score existente
              user_movie.update(score: score)
            end
          else
            errors << "Movie '#{movie_title}' directed by '#{director}' not found"
          end
        rescue => e
          errors << "Error processing entry: #{e.message}"
        end
      end

      if errors.empty?
        flash[:success] = "Ratings submitted successfully"
      else
        flash[:error] = "Errors occurred while processing the file: #{errors.join(', ')}"
      end
    else
      flash[:error] = "No file uploaded"
    end

    redirect_to movies_path
  end
end
