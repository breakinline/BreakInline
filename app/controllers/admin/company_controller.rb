class Admin::CompanyController < ApplicationController
  def update
    company = Company.find(params[:id])
    company.name = params[:name]
    company.context = params[:context]
    company.save
    render :json => '{"success":"Updated Successfully", "name":"' + company.name + '","id":"' +
      'src/' + company.id.to_s + '","iconCls":"company"}'
  end
  def show
    company = Company.find(params[:id])
    render :json => company.to_json
  end   
end