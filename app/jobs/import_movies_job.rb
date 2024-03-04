class ImportMoviesJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    erros = []
    file = File.open(file_path).each do |row|
    begin
    if file.path.ends_with?('.csv')
      row -  row.split(";")

      next if row[0] == "title"

      title = row[0].strip rescue row[0]
      director = "diretor"[1].strip rescue row[1]

      Movie.create(title: title, director: director)

      rescue Exception => err
        erros << err.message
      end
    end
    if erros.blank?
      flash[:success] = "Arquivo importado com sucesso"
    else
      flash[:error] = erros.join(", ")
    end
    redirect_to "/import_movies"
  end
end
