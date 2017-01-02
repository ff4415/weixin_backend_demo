class WelcomeController < ApplicationController
	def welcome
		render json: "hello,this is handle view" if params[:signature] == nil
		token = "Yilaster"
		list = [token ,params[:timestamp] ,params[:nonce]]
		sha1 = list.sort_by{|x| x.to_s}.join
		require 'digest/sha1'
		hashcode = Digest::SHA1.hexdigest sha1
		p "#{Time.now}"
		p "handle/GET func: #{hashcode} #{params[:signature]}"
		self.menu
		render json: params[:echostr] if hashcode == params[:signature]
#		h = {:x=>"bye",:y=>"hash",:user=>"wow"}

#		render xml: h.to_xml(:root=>"xml")
	end

	def message
		if params[:xml][:MsgType] == "text"
			p "#{Time.now}"
			p params
			p params[:xml]
			toUserName = params[:xml][:FromUserName]
			fromUserName = params[:xml][:toUserName]
			createTime = Time.now.strftime("%Y%m%d%H%M%S")
			content = "你好"
			xmlForm = """
									<xml>
									<ToUserName><![CDATA[#{toUserName}]]></ToUserName>
									<FromUserName><![CDATA[#{fromUserName}]]></FromUserName>
									<CreateTime>#{createTime}</CreateTime>
									<MsgType><![CDATA[text]]></MsgType>
									<Content><![CDATA[#{content}]]></Content>
									</xml>
								"""
			reply = {
							 :toUserName=>"<![CDATA[#{params[:xml][:FromUserName]}]]>",
			:FromUserName=>"<![CDATA[#{params[:xml][:toUserName]}]]>",
				:CreateTime=>"#{Time.now.strftime("%Y%m%d%H%M%S")}",
					:MsgType=>"<![CDATA[#{params[:xml][:MsgType]}]]>",
					:Content=>"<![CDATA[你好]]>"
							 }
							 render json: xmlForm
			#			render xml: reply.to_xml(:root=>"xml")
			#		render xml: "success"
		else
			render xml: "success"
		end
	end

	def menu 
		require 'net/http'
		uri = URI('https://api.weixin.qq.com/cgi-bin/token')
		params = {:grant_type=> "client_credential", :appid=> "wx92fae6274d8de04f", :secret=> "b0793e9d82e808a7cd0997d9f90938a6"}
		uri.query = URI.encode_www_form(params)

	 res = Net::HTTP.get_response(uri)
	 hash = JSON.parse res.body
	 p hash
	 p "access_token : #{hash["access_token"]}"

	 pJson = 
		{
			"button":
			[ 
				{
					"type": "click", 
					"name": "开发指引",
					"key":  "mpGuide" 
				},
				{
					"name": "公众平台",
					"sub_button":
						[
							{
								"type": "view",
								"name": "更新公告",
								"url": "http://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1418702138&token=&lang=zh_CN" 
							},
							{
								"type": "view",
								"name": "接口权限说明",
								"url": "http://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1418702138&token=&lang=zh_CN" 
							},
							{
							"type": "view",
							"name": "返回码说明",
							"url": "http://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1433747234&token=&lang=zh_CN" 
							}
						]
					},
					{
						"type": "media_id",
						"name": "旅行",
						"media_id": "z2zOokJvlzCXXNhSjF46gdx6rSghwX2xOD5GUV9nbX4" 
					}
				]
			}

#	poJson = JSON.parse pJson
#	p poJson

	pj = {
	"button":[
						{
							"name":"点单",
							"sub_button":[
								{
									"type":"view",
									"name":"菜单",
									"url":"http://www.soso.com/" 
								},
								{
									"type":"view",
									"name":"优惠卷",
									"url":"http://v.qq.com/" 
								},
							]
						},
						{
									"type":"view",
									"name":"投票",
									"url":"http://v.qq.com/"
						}
					]
	}

	uri = "https://api.weixin.qq.com/cgi-bin/menu/create?access_token=#{hash["access_token"]}"
	require 'rest-client'
	payload = pj.to_json.gsub!(/\\u([0-9a-z]{4})/) { |s| [$1.to_i(16)].pack("U") }
	payload = pj.to_json if payload.blank?
	p payload.to_json
	res = RestClient.post(uri, payload)
	 p res.body
	end

	def void
	end
end
