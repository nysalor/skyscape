# -*- coding: utf-8 -*-
require 'skyscape'

describe Skyscape do
  before do
    File.delete fixture_db
    create_test_db
    @skyscape = Skyscape.new fixture_db
  end

  it "Skyscape.new fileでファイルが開かれること" do
    @skyscape.should be_is_a(Skyscape)
  end

  it "set_search_optsでオプションが設定されること" do
    @skyscape.set_search_opts(:word => 'rabbit', :name => 'bravo', :start => 100)
    @skyscape.instance_eval('build_params').should == ['%rabbit%', '%bravo%', 100]
  end

  it "search(:word => word)で全ての発言から検索されること" do
    results = @skyscape.search(:word => 'rabbit')
    results[0].should == fixture_data[0]
  end

  it "search(:word => word, :name => name)で特定のユーザの発言から検索されること" do
    results = @skyscape.search(:word => 'tool', :name => 'bravo')
    results[0].should == fixture_data[1]
  end

  it "search(:start => time)で一定時刻以降の発言から検索されること" do
    results = @skyscape.search(:start => set_time('2011-05-01 00:00:00'))
    results[0].should == fixture_data[2]
  end

  it "search(:end => time)で一定時刻以前の発言から検索されること" do
    results = @skyscape.search(:end => set_time('2010-05-01 00:00:00'))
    results[0].should == fixture_data[0]
  end

  it "search(:start => time, :end => time)で一定時間内の発言から検索されること" do
    results = @skyscape.search(:start => set_time('2010-05-01 00:00:00'), :end => set_time('2011-05-01 00:00:00'))
    results[0].should == fixture_data[1]
  end
end

def create_test_db
  test_db = SQLite3::Database.new(fixture_db)
  create_sql = <<SQL
create table Messages (
  timestamp integer,
  from_dispname varchar(255),
  body_xml varchar(255),
  chatname varchar(255)
);
SQL
  test_db.execute create_sql
  insert_sql = "insert into Messages values (?, ?, ?, ?)"
  fixture_data.each{|x| test_db.execute(insert_sql, *x)}
end

def fixture_db
  @fixture_db ||= "./spec/fixtures/test.db"
end

def fixture_data
  @fixture_data ||= [
              [set_time('2010-01-01 00:00:00'),
               'alpha',
               'tool dog cat rabbit.',
               'test_chat1'],
              [set_time('2011-01-01 00:00:00'),
               'bravo',
               'tool, hunter, talor, soldier, spy.',
               'test_chat1'],
              [set_time('2012-01-01 00:00:00'),
               'charlie',
               'Without tools he is nothing, with tools he is all.',
               'test_chat2']]
end

def set_time(dt)
  Time.strptime(dt, '%Y-%m-%d %H:%M:%S').to_i
end
