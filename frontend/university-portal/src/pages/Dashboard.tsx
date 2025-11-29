import React, { useState, useEffect } from 'react';
import {
  Container,
  Typography,
  Grid,
  Card,
  CardContent,
  Box,
  Avatar,
  IconButton,
} from '@mui/material';
import {
  AssignmentOutlined,
  SchoolOutlined,
  VerifiedUserOutlined,
  Refresh,
  TrendingUp,
} from '@mui/icons-material';
import { CertificateService } from '../services/certificateService';
import { Certificate } from '../types';

interface StatsCardProps {
  title: string;
  value: string | number;
  icon: React.ReactElement;
  color: string;
  subtitle?: string;
}

const StatsCard: React.FC<StatsCardProps> = ({ title, value, icon, color, subtitle }) => {
  return (
    <Card
      sx={{
        height: '100%',
        transition: 'all 0.3s ease',
        '&:hover': {
          transform: 'translateY(-2px)',
          boxShadow: 3,
        },
      }}
    >
      <CardContent>
        <Box sx={{ display: 'flex', alignItems: 'center', mb: 2 }}>
          <Avatar
            sx={{
              bgcolor: color,
              mr: 2,
              width: 56,
              height: 56,
            }}
          >
            {icon}
          </Avatar>
          <Box sx={{ flexGrow: 1 }}>
            <Typography
              variant="h4"
              component="div"
              fontWeight="bold"
              color="text.primary"
            >
              {typeof value === 'number' ? value.toLocaleString() : value}
            </Typography>
            <Typography variant="h6" color="text.secondary">
              {title}
            </Typography>
          </Box>
        </Box>
        
        {subtitle && (
          <Typography variant="body2" color="text.secondary">
            {subtitle}
          </Typography>
        )}
      </CardContent>
    </Card>
  );
};

const Dashboard: React.FC = () => {
  const [certificates, setCertificates] = useState<Certificate[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchCertificates();
  }, []);

  const fetchCertificates = async () => {
    try {
      setLoading(true);
      const data = await CertificateService.getCertificates();
      setCertificates(data);
    } catch (error) {
      console.error('Failed to fetch certificates:', error);
    } finally {
      setLoading(false);
    }
  };

  // Calculate stats from actual data
  const totalCertificatesIssued = certificates.length;
  const activeCertificates = certificates.filter(cert => cert.status === 'ACTIVE').length;
  const revokedCertificates = certificates.filter(cert => cert.status === 'REVOKED').length;

  // Get recent certificates (last 5)
  const recentCertificates = certificates
    .sort((a, b) => new Date(b.createdAt || b.issueDate).getTime() - new Date(a.createdAt || a.issueDate).getTime())
    .slice(0, 5);

  const handleRefresh = () => {
    fetchCertificates();
  };

  return (
    <Container maxWidth="xl">
      {/* Header */}
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 4 }}>
        <Box>
          <Typography variant="h4" component="h1" fontWeight="bold" gutterBottom>
            University Dashboard
          </Typography>
          <Typography variant="body1" color="text.secondary">
            Welcome back! Here's an overview of your certificate management activities.
          </Typography>
        </Box>
        <IconButton color="primary" size="large" onClick={handleRefresh}>
          <Refresh />
        </IconButton>
      </Box>

      {/* Stats Cards */}
      <Grid container spacing={3} sx={{ mb: 4 }}>
        <Grid item xs={12} sm={6} md={3}>
          <StatsCard
            title="Total Certificates"
            value={totalCertificatesIssued}
            icon={<AssignmentOutlined />}
            color="primary.main"
            subtitle="All time issued"
          />
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <StatsCard
            title="Active Certificates"
            value={activeCertificates}
            icon={<SchoolOutlined />}
            color="success.main"
            subtitle="Currently valid"
          />
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <StatsCard
            title="Revoked Certificates"
            value={revokedCertificates}
            icon={<VerifiedUserOutlined />}
            color="error.main"
            subtitle="Revoked certificates"
          />
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <StatsCard
            title="Verification Rate"
            value="96%"
            icon={<VerifiedUserOutlined />}
            color="info.main"
            subtitle="Successful verifications"
          />
        </Grid>
      </Grid>

      {/* Recent Activity */}
      <Grid container spacing={3}>
        <Grid item xs={12}>
          <Card>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center', mb: 3 }}>
                <TrendingUp sx={{ mr: 1, color: 'primary.main' }} />
                <Typography variant="h6" component="h2">
                  Recently Issued Certificates
                </Typography>
              </Box>
              
              <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
                {loading ? (
                  <Typography variant="body2" color="text.secondary">
                    Loading certificates...
                  </Typography>
                ) : recentCertificates.length === 0 ? (
                  <Typography variant="body2" color="text.secondary">
                    No certificates issued yet
                  </Typography>
                ) : (
                  recentCertificates.map((cert) => (
                    <Box
                      key={cert.certificateId}
                      sx={{
                        p: 2,
                        border: '1px solid #e5e7eb',
                        borderRadius: 2,
                        display: 'flex',
                        justifyContent: 'space-between',
                        alignItems: 'center',
                        '&:hover': {
                          bgcolor: 'rgba(25, 118, 210, 0.04)',
                        },
                      }}
                    >
                      <Box>
                        <Typography variant="subtitle2" fontWeight="medium">
                          {cert.studentName}
                        </Typography>
                        <Typography variant="body2" color="text.secondary">
                          {cert.courseName} • Grade: {cert.grade}
                        </Typography>
                      </Box>
                      <Typography variant="caption" color="text.secondary">
                        {new Date(cert.createdAt || cert.issueDate).toLocaleDateString()}
                      </Typography>
                    </Box>
                  ))
                )}
              </Box>
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Container>
  );
};

export default Dashboard;