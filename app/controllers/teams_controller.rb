class TeamsController < ApplicationController
  def index
    @classroom = Classroom.find(params[:classroom_id])
  end
  def create
    @number = params[:teams].to_i
    @students = []
    Classroom.find(params[:classroom]).students.each do |student|
      @students << student
    end
    @teams = @students.shuffle.in_groups(@number)
    p @teams
    @t = []
    @teams.each do |team|
      t = Team.create(name: Faker::Team.creature.capitalize, classroom_id: params[:classroom])
      team.each do |student|
        if t.present? && student.present?
          StudentTeam.create(student_id: student.id, team_id: t.id)
        else
          break
        end
      end
      @t << t
    end
    redirect_to "/teachers/#{params[:teacher_id]}/classrooms/#{params[:classroom]}/teams"
  end

  def destroy
    @classroom = Classroom.find(params[:classroom_id])
    @classroom.teams.each do |team|
      team.destroy
    end
    redirect_to "/teachers/#{params[:teacher_id]}/classrooms/#{params[:classroom_id]}"
  end
end