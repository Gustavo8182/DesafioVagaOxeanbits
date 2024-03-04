class ImportMoviesController < ApplicationController
  require 'csv'

  def index
    render 'import_movies'
  end

  def process_file
    erros = []

    # Verifica se o arquivo foi enviado corretamente
    if params[:file].present? && params[:file].respond_to?(:tempfile)
      file_path = params[:file].tempfile.path

      File.open(file_path).each do |row|
        begin
          if file_path.ends_with?('.csv')
            row = row.split(";")

            next if row[0] == "title"

            title = row[0].strip rescue row[0]
            director = row[1].strip rescue row[1]

            Movie.create(title: title, director: director)
          end
        rescue Exception => err
          erros << err.message
        end
      end

      if erros.blank?
        flash[:success] = "Arquivo importado com sucesso"
      else
        flash[:error] = erros.join(", ")
      end
    else
      flash[:error] = "Nenhum arquivo enviado"
    end

    redirect_to import_movies_path
  end
end
