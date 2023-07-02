require "rails_helper"

RSpec.describe "Projects", type: :request do
  context "as an authenticated user" do
    before { @user = create(:user) }

    context "with valid attributes" do
      it "adds a project" do
        project_params = attributes_for(:project)

        sign_in @user

        expect {
          post projects_path, params: { project: project_params }
        }.to change(@user.projects, :count).by(1)
      end
    end
  end
end
