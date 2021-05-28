import java.util.Arrays; 
import java.util.Random;
import java.util.*; 
import java.lang.*;
public class Network {

   
  private double[][] output;
  private double[][][] weights; 
  private double[][] bias; 



  public final int[] NETWORK_LAYER_SIZES;
  public final int INPUT_SIZE;
  public final int OUTPUT_SIZE;
  public final int NETWORK_SIZE;


  public Network(int[] NETWORK_LAYER_SIZES, NetworkTools networkTools)
  {
    this.NETWORK_LAYER_SIZES = NETWORK_LAYER_SIZES;
    this.INPUT_SIZE = NETWORK_LAYER_SIZES[0];
    this.NETWORK_SIZE = NETWORK_LAYER_SIZES.length; 
    this.OUTPUT_SIZE = NETWORK_LAYER_SIZES[NETWORK_SIZE -1];

    this.output = new double[NETWORK_SIZE][];
    this.weights = new double[NETWORK_SIZE][][];
    this.bias = new double [NETWORK_SIZE][];

    for (int i = 0; i < NETWORK_SIZE; i++)
    {
      this.output[i] = new double[NETWORK_LAYER_SIZES[i]];
      this.bias[i] = networkTools.createRandomArray(NETWORK_LAYER_SIZES[i], -1f, 1f );

      if (i > 0)
      {
        weights[i] = networkTools.createRandomArray(NETWORK_LAYER_SIZES[i], NETWORK_LAYER_SIZES[i-1], -1f, 1f);
      }
    }
  }
  public double[] calculate(double... input) {
    if (input.length != this.INPUT_SIZE) {
      return null;
    }
    this.output[0] = input; 
    for (int layer = 1; layer < NETWORK_SIZE; layer++)
    {
      for (int neuron = 0; neuron < NETWORK_LAYER_SIZES[layer]; neuron++)
      {
        double sum = bias[layer][neuron];
        for (int prevNeuron = 0; prevNeuron < NETWORK_LAYER_SIZES[layer-1]; prevNeuron++)
        {
          sum+= output[layer-1][prevNeuron] * weights[layer][neuron][prevNeuron];
        }
       if(layer != NETWORK_SIZE-1)
        {
        output[layer][neuron] = Activation(sum);
        }
       else
        {
       output[layer][neuron] = sigmoid(sum);
        }
      }
    }
    return output[NETWORK_SIZE-1];
  }

  private double sigmoid(double x)
  {
    return 1d / (1 + Math.exp(-x));
  }
  private double Activation(double x)
  {
   return Math.max(0,x); 
  }

  public void Mutate(float mutationrate, NetworkTools networkTools, Random rand)
  {
    for (int layer = 1; layer < NETWORK_SIZE; layer++)
    {
      for (int neuron = 0; neuron < NETWORK_LAYER_SIZES[layer]; neuron++)
      {
        if (networkTools.randomValue(0, 1) < mutationrate)
        {
          this.bias[layer][neuron] += (rand.nextGaussian() / 5f + 0);
          if(this.bias[layer][neuron] > 1)
          {
            this.bias[layer][neuron] = 1;
          }
          if(this.bias[layer][neuron] < -1)
          {
            this.bias[layer][neuron] = -1;
          }
        }
        for (int prevNeuron = 0; prevNeuron < NETWORK_LAYER_SIZES[layer-1]; prevNeuron++)
        {
          if (networkTools.randomValue(0, 1) < mutationrate)
          {
            this.weights[layer][neuron][prevNeuron] += (rand.nextGaussian() / 5f);
           if(this.weights[layer][neuron][prevNeuron] > 1)
          {
            this.weights[layer][neuron][prevNeuron] = 1;
          }
          if(this.weights[layer][neuron][prevNeuron] < -1)
          {
            this.weights[layer][neuron][prevNeuron] = -1;
          }
          }
        }
      }
    }
  }
  public Network Copy(NetworkTools networkTools)
  {
    Network NewNet = new Network(NETWORK_LAYER_SIZES, networkTools);
    for (int layer = 1; layer < NETWORK_SIZE; layer++)
    {
      for (int neuron = 0; neuron < NETWORK_LAYER_SIZES[layer]; neuron++)
      {
        NewNet.bias[layer][neuron] = this.bias[layer][neuron];
        for (int prevNeuron = 0; prevNeuron < NETWORK_LAYER_SIZES[layer-1]; prevNeuron++)
        {
          NewNet.weights[layer][neuron][prevNeuron] = this.weights[layer][neuron][prevNeuron];
        }
      }
    }
    return NewNet;
  }


  public Network[] Crossover(Network parent1, Network parent2, NetworkTools networkTools)
  {
    Network child1;
    Network child2;

    
    child1 = new Network(NETWORK_LAYER_SIZES, networkTools);
    child2 = new Network(NETWORK_LAYER_SIZES, networkTools);


   int Layer = (int) (networkTools.randomValue(1, NETWORK_SIZE));
   int Neuron = (int) (networkTools.randomValue(0, NETWORK_LAYER_SIZES[Layer] + 1));
   int PrevNeuron = (int) (networkTools.randomValue(0, NETWORK_LAYER_SIZES[Layer-1] + 1));
   
   
   
   for (int layer = 1; layer <= Layer; layer++)
    {
      for (int neuron = 0; neuron < Neuron; neuron++)
      {
          child1.bias[layer][neuron] = parent1.bias[layer][neuron];
          child2.bias[layer][neuron] = parent2.bias[layer][neuron];
        
        for (int prevNeuron = 0; prevNeuron < PrevNeuron; prevNeuron++)
        {
            child1.weights[layer][neuron][prevNeuron] = parent1.weights[layer][neuron][prevNeuron];
            child2.weights[layer][neuron][prevNeuron] = parent2.weights[layer][neuron][prevNeuron];
        }
      }
    }
    
    for (int layer = (Layer); layer <= NETWORK_SIZE; layer++)
    {
      for (int neuron = Neuron; neuron < NETWORK_LAYER_SIZES[layer]; neuron++)
      {
          child1.bias[layer][neuron] = parent2.bias[layer][neuron];
          child2.bias[layer][neuron] = parent1.bias[layer][neuron];
        
        for (int prevNeuron = PrevNeuron; prevNeuron < NETWORK_LAYER_SIZES[layer-1]; prevNeuron++)
        {
            child1.weights[layer][neuron][prevNeuron] = parent2.weights[layer][neuron][prevNeuron];
            child2.weights[layer][neuron][prevNeuron] = parent1.weights[layer][neuron][prevNeuron];
        }
      }
    }
    
   return new Network[] {child1, child2}; 
   
  }
  
  
  public int Crossyover(Network parent1, Network parent2, Network[] childpool,int i,float mutationrate, NetworkTools networkTools)
  {
    Network child1;
    Network child2;

    
    child1 = new Network(NETWORK_LAYER_SIZES, networkTools);
    child2 = new Network(NETWORK_LAYER_SIZES, networkTools);

   int Layer = (int) (networkTools.randomValue(1, NETWORK_SIZE));
   int Neuron = (int) (networkTools.randomValue(0, NETWORK_LAYER_SIZES[Layer] + 1));
   int PrevNeuron = (int) (networkTools.randomValue(0, NETWORK_LAYER_SIZES[Layer-1] + 1));
   
   int Layer2 = (int) (networkTools.randomValue(Layer, NETWORK_SIZE));
   int Neuron2;
   int PrevNeuron2;
  if(Layer2== Layer)
  {
      Neuron2 = (int) (networkTools.randomValue(Neuron, NETWORK_LAYER_SIZES[Layer2] + 1));
      PrevNeuron2 = (int) (networkTools.randomValue(PrevNeuron, NETWORK_LAYER_SIZES[Layer2-1] + 1));
  }
  else
  {
     Neuron2 = (int) (networkTools.randomValue(0, NETWORK_LAYER_SIZES[Layer2] + 1));
     PrevNeuron2 = (int) (networkTools.randomValue(0, NETWORK_LAYER_SIZES[Layer2-1] + 1));
  }
   
   for (int layer = 1; layer < NETWORK_SIZE; layer++)
    {
      for (int neuron = 0; neuron < NETWORK_LAYER_SIZES[layer]; neuron++)
      {
          child1.bias[layer][neuron] = parent1.bias[layer][neuron];
          child2.bias[layer][neuron] = parent2.bias[layer][neuron];
        
        for (int prevNeuron = 0; prevNeuron < NETWORK_LAYER_SIZES[layer-1]; prevNeuron++)
        {
            child1.weights[layer][neuron][prevNeuron] = parent1.weights[layer][neuron][prevNeuron];
            child2.weights[layer][neuron][prevNeuron] = parent2.weights[layer][neuron][prevNeuron];
        }
      }
    }
    
    for (int layer = Layer; layer <= Layer2; layer++)
    {
      for (int neuron = Neuron; neuron < Neuron2; neuron++)
      {
          child1.bias[layer][neuron] = parent2.bias[layer][neuron];
          child2.bias[layer][neuron] = parent1.bias[layer][neuron];
        
        for (int prevNeuron = PrevNeuron; prevNeuron < PrevNeuron2; prevNeuron++)
        {
            child1.weights[layer][neuron][prevNeuron] = parent2.weights[layer][neuron][prevNeuron];
            child2.weights[layer][neuron][prevNeuron] = parent1.weights[layer][neuron][prevNeuron];
        }
      }
    }
    
   childpool[i] = child1; 
   childpool[i].Mutate(mutationrate,networkTools,rand);//.01
   i++;
   childpool[i] = child2;
   childpool[i].Mutate(mutationrate,networkTools,rand);//.01
   i++;
   return i;
  }
}
