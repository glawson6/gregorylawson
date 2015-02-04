require 'sinatra'
require 'pdfkit'
#require_relative './model/cookbook'

CSS_DIR = File.dirname(__FILE__) + '/public/css'
get '/resume' do
  puts CSS_DIR
  erb :resume_page
end

get '/about' do
  @active = "about"
  erb :about
end

get '/pdf' do
  content_type 'application/pdf'
  html = erb(:resume_pdf,:layout => false)
  #render(:erb, template, options, locals, &block)
  #kit = PDFKit.new(html, :page_size => 'Letter')
  kit = PDFKit.new(html, {})
  kit.stylesheets << CSS_DIR + '/bootstrap.min.css'
  kit.stylesheets << CSS_DIR + '/main.css'
  #send_file 'foo.png'
  stream do |out|
    out << kit.to_pdf
  end
end
