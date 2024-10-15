defmodule SkillSanityWeb.SkillControllerTest do
  use SkillSanityWeb.ConnCase

  import SkillSanity.SkillsFixtures

  alias SkillSanity.Skills.Skill

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "search" do
    test "searches one skill", %{conn: conn} do
      {skill, _} = skill_fixture(%{name: "React", variation: "react.js"})

      conn = get(conn, ~p"/api/skills/search?skill=react")
      response = json_response(conn, 200)["data"]

      assert response = %{"skill" => %{id: skill.id}}
    end

    test "searches multiple skills", %{conn: conn} do
      {skill_1, _} = skill_fixture(%{name: "React", variation: "react.js"})
      {skill_2, _} = skill_fixture(%{name: "Angular", variation: "angular.js"})

      conn = get(conn, ~p"/api/skills/search?skills=react,angular")
      response = json_response(conn, 200)["data"]

      assert response = [%{"skill" => %{id: skill_1.id}}, %{"skill" => %{id: skill_2.id}}]
    end

    test "respects skills order from query", %{conn: conn} do
      {skill_1, _} = skill_fixture(%{name: "React", variation: "react.js"})
      {skill_2, _} = skill_fixture(%{name: "Angular", variation: "angular.js"})

      conn = get(conn, ~p"/api/skills/search?skills=angular,react")
      response = json_response(conn, 200)["data"]

      [match_1 | [match_2 | _]] = response

      assert response = [%{"skill" => %{id: skill_1.id}}, %{"skill" => %{id: skill_2.id}}]
    end
  end
end
