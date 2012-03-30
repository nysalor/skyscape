class Skyscape
  require 'sqlite3'

  def initialize(file)
    @dbh = SQLite3::Database.new(file)
  end

  def set_search_opts(opts)
    @search_opts = opts
  end

  def search(opts = nil)
    set_search_opts opts
    dbh.execute(build_query, build_params)
  end

  private

  def dbh
    @dbh
  end

  def search_opts
    @search_opts ||= {}
  end

  def build_query
    conditions = []
    conditions << 'body_xml like ?' if search_opts[:word]
    conditions << 'from_dispname like ?' if search_opts[:name]
    conditions << 'chatname like ?' if search_opts[:chat]
    conditions << 'timestamp > ?' if search_opts[:start].to_i > 0 
    conditions << 'timestamp < ?' if search_opts[:end].to_i > 0 
    search_sql_base + conditions.join(' AND ')
  end

  def build_params
    [build_str_params, build_num_params].flatten
  end

  def build_str_params
    [:word, :name, :chat].map{|x| search_opts[x]}.compact.map{|y| "%#{y}%"}
  end

  def build_num_params
    [:start, :end].map{|x| search_opts[x]}.compact.map(&:to_i)
  end

  def search_sql_base
    'select * from Messages where ' 
  end

    def search_by_word_and_name_sql
    'select * from Messages where body_xml like ? and from_dispname like ?'
  end
end
