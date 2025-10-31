/** @type {import('next').NextConfig} */
const nextConfig = {
    output: 'export',
    images: {
        unoptimized: true,
        remotePatterns: [
          {
            protocol: 'https',
            hostname: 'altayenergoklaster.ru',
            port: '',
            pathname: '/**',
          },
        ],
      },
};

export default nextConfig;
