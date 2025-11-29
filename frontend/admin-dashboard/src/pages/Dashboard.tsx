import React, { useEffect, useState } from 'react';
import {
  Container,
  Typography,
  Grid,
  Box,
  IconButton,
  Alert,
  CircularProgress,
} from '@mui/material';
import {
  People,
  School,
  Assignment,
  Refresh,
} from '@mui/icons-material';
import { StatsCard, SystemHealthCard } from '../components';
import { adminService } from '../services';
import { DashboardStats } from '../types';

export const Dashboard: React.FC = () => {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [refreshing, setRefreshing] = useState(false);

  const loadDashboardData = async () => {
    try {
      setError(null);
      const data = await adminService.getDashboardStats();
      setStats(data);
    } catch (err: any) {
      setError(err.message || 'Failed to load dashboard data');
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  const handleRefresh = async () => {
    setRefreshing(true);
    await loadDashboardData();
  };

  useEffect(() => {
    loadDashboardData();
  }, []);

  if (loading) {
    return (
      <Container maxWidth="xl" sx={{ py: 4 }}>
        <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: 200 }}>
          <CircularProgress />
        </Box>
      </Container>
    );
  }

  if (error) {
    return (
      <Container maxWidth="xl" sx={{ py: 4 }}>
        <Alert severity="error" sx={{ mb: 3 }}>
          {error}
        </Alert>
        <Box sx={{ textAlign: 'center' }}>
          <IconButton onClick={handleRefresh} disabled={refreshing}>
            <Refresh />
          </IconButton>
        </Box>
      </Container>
    );
  }

  return (
    <Container maxWidth="xl" sx={{ py: 4 }}>
      {/* Header */}
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 4 }}>
        <Typography variant="h4" component="h1" fontWeight="bold">
          Admin Dashboard
        </Typography>
        <IconButton onClick={handleRefresh} disabled={refreshing}>
          <Refresh sx={{ animation: refreshing ? 'spin 1s linear infinite' : 'none' }} />
        </IconButton>
      </Box>

      {stats && (
        <>
          {/* Stats Cards */}
          <Grid container spacing={3} sx={{ mb: 4 }}>
            <Grid item xs={12} sm={6} md={4}>
              <StatsCard
                title="Total Users"
                value={stats.totalUsers}
                icon={<People />}
                color="primary.main"
                subtitle="All registered users"
              />
            </Grid>
            <Grid item xs={12} sm={6} md={4}>
              <StatsCard
                title="Universities"
                value={stats.totalUniversities}
                icon={<School />}
                color="secondary.main"
                subtitle="Verified institutions"
              />
            </Grid>
            <Grid item xs={12} sm={6} md={4}>
              <StatsCard
                title="Certificates"
                value={stats.totalCertificates}
                icon={<Assignment />}
                color="success.main"
                subtitle="Total issued"
              />
            </Grid>
          </Grid>

          <Grid container spacing={3} justifyContent="center">
            {/* System Health */}
            <Grid item xs={12} md={8} lg={6}>
              <SystemHealthCard health={stats.systemHealth} />
            </Grid>
          </Grid>
        </>
      )}

      <style>
        {`
          @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
          }
        `}
      </style>
    </Container>
  );
};