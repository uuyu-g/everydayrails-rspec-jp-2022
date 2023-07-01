require "rails_helper"

RSpec.describe Project, type: :model do
  # ユーザー単位では重複したプロジェクト名を許可しないこと
  it "does not allow duplicate project names per user" do
    user =
      create(
        :user,
        first_name: "Joe",
        last_name: "Tester",
        email: "joetester@example.com",
        password: "dottle-nouveau-pavilion-tights-furze"
      )

    user.projects.create(name: "Test Project")

    new_project = user.projects.build(name: "Test Project")

    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  # 二人のユーザーが同じ名前を使うことは許可すること
  it "allows two users to share a project name" do
    user = create(:user, email: "joetester@example.com")
    user.projects.create(name: "Test Project")

    other_user = create(:user, email: "janetester@example.com")
    other_project = other_user.projects.build(name: "Test Project")

    expect(other_project).to be_valid
  end

  describe "late status" do
    # 締切日が過ぎていれば遅延していること
    it "is late when the due date is past today" do
      project = build(:project, :due_yesterday)
      expect(project).to be_late
    end
    # 締切日が今日ならスケジュールどおりであること
    it "is on time when the due date is today" do
      project = build(:project, :due_today)
      expect(project).to_not be_late
    end
    # 締切日が未来ならスケジュールどおりであること
    it "is on time when the due date is in the future" do
      project = build(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end

  it "can have many notes" do
    project = create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end
end
