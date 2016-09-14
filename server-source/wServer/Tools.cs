using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace wServer
{
    public class Tools
    {
        public static void ArrayShuffle<T>(T[] array)
        {
            //Fischer-Yates Array Shuffle
            Random rand = new Random();
            int n = array.Length;
            for (int i = 0; i < n; i++)
            {
                int r = i + (int)(rand.NextDouble() * (n - i));
                T t = array[r];
                array[r] = array[i];
                array[i] = t;
            }
        }
        
        public static void ArrayShuffleRNG<T>(T[] array)
        {
            //Fischer-Yates Array Shuffle with RNG-based NextDouble
            Random rand = new Random();
            int n = array.Length;
            for (int i = 0; i < n; i++)
            {
                int r = i + (int)(CryptoRandom.NextDouble() * (n - i));
                T t = array[r];
                array[r] = array[i];
                array[i] = t;
            }
        }
    }

    public class CryptoRandom
    {
        //I will organize this later - proph

        public static double NextDouble()
        {
            double output = 0.0d;
            var r = RandomNumberGenerator.Create();
            byte[] b = new byte[4];
            r.GetNonZeroBytes(b);
            output = (double)BitConverter.ToUInt32(b, 0) / uint.MaxValue;
            r.Dispose();
            r = null;
            return output;
        }

        public static int Next(int minValue, int maxValue)
        {
            long range = maxValue - minValue;
            return (int)(Math.Round(NextDouble() * range) + minValue);
        }

        public static uint NextUInt()
        {
            uint output = 1234;
            var r = RandomNumberGenerator.Create();
            byte[] b = new byte[4];
            r.GetNonZeroBytes(b);
            output = BitConverter.ToUInt32(b, 0);
            r.Dispose();
            r = null;
            return output;
        }

    }
}
