<template>
  <FirstTimeUserCards
    v-if="isFirstTimeUser && gamesFetched"
    :games="currentGames"
    :open-games-count="openGamesCount"
    @anonymity_confirmed="$emit('anonymity_confirmed', $event)"
  />
  <v-container v-else-if="gamesFetched">
    <Suspense>
      <YourGames
        v-if="profile.registered || profile.anonymityConfirmedAt"
        :games="yourGames"
        :profile="profile"
      />
    </Suspense>
    <Suspense>
      <CurrentGames :games="currentGames" />
    </Suspense>
  </v-container>
  <v-container
    v-else
    class="text-center"
  >
    <v-progress-circular
      indeterminate
      color="primary-darken-1"
      size="100"
      class="mt-10"
    />
  </v-container>
</template>

<script>
import CurrentGames from '../components/CurrentGames.vue';
import FirstTimeUserCards from '../components/FirstTimeUserCards.vue';
import YourGames from '../components/YourGames.vue';

export default {
  name: 'Home',
  components: {
    CurrentGames, FirstTimeUserCards, YourGames,
  },
  props: {
    games: { type: Array, default: () => [] },
    gamesFetched: { type: Boolean, default: false },
    openGamesCount: { type: Number, default: 0 },
    profile: { type: Object, default: () => {} },
    users: { type: Array, default: () => [] },
  },
  emits: ['anonymity_confirmed'],
  computed: {
    yourGames() {
      return this.games.filter((game) => {
        let inGame = false;
        game.players.forEach((player) => {
          if (player.name === this.profile.username) {
            inGame = true;
          }
        });
        return inGame && !game.forceEndedAt && !game.clonedFromGame;
      });
    },
    currentGames() {
      return this.games.filter(
        (game) => game.startedAt && !game.forceEndedAt && !game.winner && !game.clonedFromGame && game.players.length > 1,
      );
    },
    currentSoloGames() {
      return this.games.filter(
        (game) => game.startedAt && !game.forceEndedAt && !game.winner && !game.clonedFromGame && game.players.length === 1,
      );
    },
    isFirstTimeUser() {
      return !this.profile.registered && !this.profile.anonymityConfirmedAt;
    },
  },
  created() {
    document.title = 'Imperial';
  },
};
</script>

<style src="../assets/tailwind.css" />
