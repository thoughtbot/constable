import AnnouncementInterests from "./../announcement-interests";

var announcementInterests = new AnnouncementInterests()

const EVENT = "update_interests";
const AnnouncementInterestsHook = {
  mounted() {
    announcementInterests.setupInterestsSelect(value => {
      let payload = {"interests": value}
      this.pushEvent(EVENT, payload);
    });

    let payload = {"interests": announcementInterests.loadInterests()}
    this.pushEvent(EVENT, payload);
  },
  updated() {
    announcementInterests.setupInterestsSelect(value => {
      let payload = {"interests": value}
      this.pushEvent(EVENT, payload);
    });
  },
};

export default AnnouncementInterestsHook;
