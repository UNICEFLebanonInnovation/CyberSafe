import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';

export function ActionGrid() {
  const actions = [
    { id: '1', title: 'CyberBuddy', icon: '🤖' },
    { id: '2', title: 'Learn', icon: '📚' },
    { id: '3', title: 'Playbooks', icon: '🛡️' },
    { id: '4', title: 'Report', icon: '🚨' },
  ];

  return (
    <View style={styles.grid}>
      {actions.map((action) => (
        <TouchableOpacity key={action.id} style={styles.card}>
          <Text style={styles.icon}>{action.icon}</Text>
          <Text style={styles.title}>{action.title}</Text>
        </TouchableOpacity>
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  grid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
    gap: 16,
  },
  card: {
    width: '47%',
    backgroundColor: '#F5F7FA',
    padding: 20,
    borderRadius: 16,
    alignItems: 'center',
  },
  icon: {
    fontSize: 32,
    marginBottom: 8,
  },
  title: {
    fontSize: 14,
    fontWeight: '600',
    color: '#333',
  },
});
