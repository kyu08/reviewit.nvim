local config = require("reviewit.config")
local comments = require("reviewit.comments")

describe("comments data access", function()
	before_each(function()
		config.setup({})
		config.state.comment_map = {
			["lua/foo.lua"] = {
				[10] = { { id = 1, body = "fix this" } },
				[25] = { { id = 2, body = "nice" }, { id = 3, body = "agreed" } },
			},
		}
	end)

	describe("get_comments_at", function()
		it("returns comments for existing path and line", function()
			local result = comments.get_comments_at("lua/foo.lua", 10)
			assert.are.equal(1, #result)
			assert.are.equal("fix this", result[1].body)
		end)

		it("returns multiple comments on the same line", function()
			local result = comments.get_comments_at("lua/foo.lua", 25)
			assert.are.equal(2, #result)
		end)

		it("returns empty table for line with no comments", function()
			local result = comments.get_comments_at("lua/foo.lua", 99)
			assert.are.same({}, result)
		end)

		it("returns empty table for unknown file", function()
			local result = comments.get_comments_at("nope.lua", 10)
			assert.are.same({}, result)
		end)
	end)

	describe("get_comment_lines", function()
		it("returns sorted line numbers", function()
			local result = comments.get_comment_lines("lua/foo.lua")
			assert.are.same({ 10, 25 }, result)
		end)

		it("returns empty table for unknown file", function()
			local result = comments.get_comment_lines("nope.lua")
			assert.are.same({}, result)
		end)
	end)
end)
