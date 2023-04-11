import { defaultClient, setup, start, DistributedTracingModes } from 'applicationinsights';

export function register() {
  if (process.env.NEXT_PUBLIC_APPLICATIONINSIGHTS_CONNECTION_STRING) {
    console.log('Initializing application insights');
    setup(process.env.NEXT_PUBLIC_APPLICATIONINSIGHTS_CONNECTION_STRING)
      .setAutoCollectConsole(false)
      .setDistributedTracingMode(DistributedTracingModes.AI_AND_W3C)
      .setSendLiveMetrics(true);
    defaultClient.setAutoPopulateAzureProperties(true);
    start();
    console.log('Done initializing application insights');
  }
}
