require 'sinatra'
require 'pdfkit'
require 'sinatra/activerecord'
#require_relative './model/cookbook'

CSS_DIR = File.dirname(__FILE__) + '/public/css'

OFFICE_COMMAND = ENV['SOFFICE_PATH']

get '/resume' do
  puts CSS_DIR
  puts OFFICE_COMMAND
  erb :resume_page
end

get '/' do
  puts CSS_DIR
  puts OFFICE_COMMAND
  erb :resume_page
end

get '/2page' do
  erb :resume_two_page, :layout => false
end

get '/text' do
  erb :resume_no_css, :layout => false
end

get '/2pagePDF' do
  content_type 'application/pdf'
  html = erb(:resume_two_page, :layout => false)
  kit = PDFKit.new(html, :page_size => 'Letter',
                   :margin_top => '0.25in',
                   :margin_right => '0.25in',
                   :margin_bottom => '0.25in',
                   :margin_left => '0.25in',)
  kit.stylesheets << CSS_DIR + '/bootstrap.min.css'
  kit.stylesheets << CSS_DIR + '/main.css'
  puts kit.command
  stream do |out|
    out << kit.to_pdf
  end
end

get '/about' do
  @active = "about"
  erb :about
end

get '/pdf' do
  content_type 'application/pdf'
  # html = erb(:resume_pdf, :layout => false)
  # kit = PDFKit.new(html, :page_size => 'Letter',
  #                  :margin_top => '0.25in',
  #                  :margin_right => '0.25in',
  #                  :margin_bottom => '0.25in',
  #                  :margin_left => '0.25in')
  # kit.stylesheets << CSS_DIR + '/bootstrap.min.css'
  # kit.stylesheets << CSS_DIR + '/main.css'
  # puts kit.command
  stream do |out|
    #out << kit.to_pdf
    out << File.binread("Resume-7-page-2015.pdf")
  end
end


get '/doc' do
  content_type 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
  html = erb(:resume_pdf, :layout => false)
  stream do |out|
    #out << to_doc(html)
    out << File.binread("Resume-7-page-2015.docx")
  end
end

## Need to come back to this method
def to_doc(html)
  file_name = "tem.txt.html"
  file = File.new(file_name, "wb+")
  file.puts(html)
  commands = [OFFICE_COMMAND, '--convert-to docx:"Office Open XML Text"', "resume.doc"]
  commands << file_name
  commands << "--headless"
  invoke = commands.join(" ")
  puts invoke
  result = IO.popen(invoke, "wb+") do |doc|
    #doc.puts(@source.to_s) if @source.html?
    doc.close_write
    doc.gets(nil)
  end

  #result = File.read(path) if path

  # $? is thread safe per http://stackoverflow.com/questions/2164887/thread-safe-external-process-in-ruby-plus-checking-exitstatus
  #raise "command failed (exitstatus=#{$?.exitstatus}): #{invoke}" if result.to_s.strip.empty? or !successful?($?)
  return File.binread("tem.txt.docx")
end

def to_file(path)
  self.to_pdf(path)
  File.new(path)
end
