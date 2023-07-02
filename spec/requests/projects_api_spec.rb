require "rails_helper"

RSpec.describe "Projects Api", type: :request do
  describe "GET /projects_apis" do
    it "works! (now write some real specs)" do
      get api_projects_path
      expect(response).to have_http_status(200)
    end
  end

  # 1件のプロジェクトを読み出すこと
  it "loads a project" do
    user = create(:user)
    create(:project, name: "Sample Project")
    create(:project, name: "Second Sample Project", owner: user)

    # index
    get api_projects_path,
        params: {
          user_email: user.email,
          user_token: user.authentication_token
        }
    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json.length).to eq 1

    # show
    project_id = json[0]["id"]
    get api_project_path(project_id),
        params: {
          user_email: user.email,
          user_token: user.authentication_token
        }
    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json["name"]).to eq "Second Sample Project"
  end

  # プロジェクトを作成できること
  it "creates a project" do
    user = create(:user)

    project_attributes = attributes_for(:project)

    expect {
      post api_projects_path,
           params: {
             user_email: user.email,
             user_token: user.authentication_token,
             project: project_attributes
           }
    }.to change(user.projects, :count).by(1)

    expect(response).to have_http_status(:success)
  end
end
