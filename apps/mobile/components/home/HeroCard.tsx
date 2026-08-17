import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';

export function HeroCard() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Welcome to CyberSafe</Text>
      <Text style={styles.subtitle}>Check links, messages, and files securely.</Text>
      <TouchableOpacity style={styles.button}>
        <Text style={styles.buttonText}>Start a Check</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: '#0056D2',
    padding: 24,
    borderRadius: 16,
    marginVertical: 16,
  },
  title: {
    color: '#FFF',
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 8,
  },
  subtitle: {
    color: '#E0E0E0',
    fontSize: 16,
    marginBottom: 16,
  },
  button: {
    backgroundColor: '#FFF',
    paddingVertical: 12,
    paddingHorizontal: 24,
    borderRadius: 8,
    alignSelf: 'flex-start',
  },
  buttonText: {
    color: '#0056D2',
    fontWeight: '600',
    fontSize: 16,
  },
});
