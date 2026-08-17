import { ScrollView, StyleSheet, SafeAreaView } from "react-native";
import { HeroCard } from "../components/home/HeroCard";
import { ActionGrid } from "../components/home/ActionGrid";
import { AlertList } from "../components/home/AlertList";

export default function Index() {
  return (
    <SafeAreaView style={styles.safeArea}>
      <ScrollView contentContainerStyle={styles.container}>
        <HeroCard />
        <ActionGrid />
        <AlertList />
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: '#FFFFFF',
  },
  container: {
    padding: 20,
  },
});
