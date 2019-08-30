import EmojiPicker from "rm-emoji-picker";

(function($) {
  $.fn.reactions = function(overrides) {
    const options = $.extend({}, $.fn.reactions.defaults, overrides);

    return this.each(function() {
      const $elem = $(this);
      const announcementId = $elem.data("announcement-id");
      const commentId = $elem.data("comment-id");
      const reactions = $elem.data("reactions");

      let reactionGroups = {};
      $.each(reactions, function(i, reaction) {
        let reactionByCurrentUser = options.current_user_id == reaction.user_id;
        if (!reactionGroups.hasOwnProperty(reaction.emoji)) {
          reactionGroups[reaction.emoji] = {
            emoji: reaction.emoji,
            count: 1,
            reactionByCurrentUser,
          };
        } else {
          $.extend(reactionGroups[reaction.emoji], {
            count: reactionGroups[reaction.emoji].count + 1,
            reactionByCurrentUser,
          });
        }
      });

      $.each(Object.values(reactionGroups), function(i, reactionGroup) {
        const $reactionPill = $(`
        <div class="reaction-pill ${
          reactionGroup.reactionByCurrentUser ? "reaction-by-current-user" : ""
        }">
          <span class="reaction-emoji">${reactionGroup.emoji}</span>
          <span class="reaction-count">${reactionGroup.count}</span>
        </div>
        `);
        $reactionPill.data("emoji", reactionGroup.emoji);
        $elem.append($reactionPill);
      });

      const addReactionId = `add-reaction-${Math.random()
        .toString(36)
        .substr(2)}`;
      const $addReactionPill = $(`
        <div id="${addReactionId}" class="add-reaction-pill">
          <span class="reaction-emoji">➕</span>
        </div>
      `);
      $elem.append($addReactionPill);

      const addReaction = function(emoji) {
        console.log("addReaction", emoji, announcementId, commentId);
      };

      const removeReaction = function(emoji) {
        console.log("removeReaction", emoji, announcementId, commentId);
      };

      const picker = new EmojiPicker({
        positioning: function(tooltip) {
          tooltip.autoPlaceVertically(-130);
        },
        callback: function(emoji, category, node) {
          addReaction(emoji.$emoji.text());
        },
      });
      picker.listenOn(
        $addReactionPill[0],
        $("#main")[0],
        $("<input type='text' />")[0],
      );

      $(document).click(function(event) {
        if (!$(event.target).closest(`#${addReactionId}`).length) {
          picker.picker_open = false;
        }
      });

      $elem.on("click", ".reaction-pill", function(event) {
        const $target = $(event.target);
        const $pill = $target.closest(".reaction-pill");
        const pillEmoji = $pill.data("emoji");
        if (reactionGroups[pillEmoji]) {
          if (reactionGroups[pillEmoji].reactionByCurrentUser) {
            removeReaction(pillEmoji);
          } else {
            addReaction(pillEmoji);
          }
        }
      });

      $elem.addClass("initialized");
    });
  };

  $.fn.reactions.defaults = {};
})(jQuery);

$(document).ready(function() {
  $(".reactions").reactions({
    current_user_id: constable.current_user_id,
  });
});
