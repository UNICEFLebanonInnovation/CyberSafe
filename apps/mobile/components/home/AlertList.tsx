import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

export function AlertList() {
  const alerts = [
    { id: '1', title: 'New Phishing Campaign Detected', severity: 'HIGH' },
    { id: '2', title: 'Weekly Challenge: Secure Passwords', severity: 'INFO' },
  ];

  return (
    <View style={styles.container}>
      <Text style={styles.sectionTitle}>Alerts & News</Text>
      {alerts.map((alert) => (
        <View key={alert.id} style={styles.alertCard}>
          <Text style={[
            styles.severity,
            alert.severity === 'HIGH' ? styles.highSeverity : styles.infoSeverity
          ]}>
            {alert.severity}
          </Text>
          <Text style={styles.title}>{alert.title}</Text>
        </View>
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    marginVertical: 16,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 12,
    color: '#111',
  },
  alertCard: {
    backgroundColor: '#FFF',
    padding: 16,
    borderRadius: 8,
    marginBottom: 8,
    borderWidth: 1,
    borderColor: '#EAEAEA',
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  severity: {
    fontSize: 12,
    fontWeight: 'bold',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 4,
  },
  highSeverity: {
    backgroundColor: '#FEE2E2',
    color: '#DC2626',
  },
  infoSeverity: {
    backgroundColor: '#E0F2FE',
    color: '#0284C7',
  },
  title: {
    fontSize: 14,
    color: '#333',
    flex: 1,
  },
});
