#include<stdio.h>
#define UPPERLIMIT 20

typedef int matrix [UPPERLIMIT][UPPERLIMIT];

int Seed;
matrix A1 ={  { 6880, 7946, 7759, 3681, 4698, 5047, 6177, 1494, 6102, 5472, 1605, 4476, 2194, 5572, 6082, 3348, 7577, 8031, 4281, 3345},  
{ 5359, 6278, 5382, 1940,  687, 2585, 1426, 1797, 2090, 4724, 3699, 2478, 1454, 4026, 3829, 2890, 5980, 5565, 7652, 5492},  
{  369,  0, 7999, 3554, 7800, 5105, 1809, 7856, 4701, 6099,  320, 7650, 4868, 7740, 3349, 1865, 6402, 1373,  189, 7003},  
{  103, 2413, 4584, 4401, 5250, 6235, 3590, 2568, 3745, 7612,  380, 4101, 1117, 97, 2249, 3352, 6019, 1961, 5093, 6442},  
{ 3098,  178, 6206, 3199, 3181,  221, 7517, 5187, 6107, 1898, 6141,  714, 7791, 3606, 1763, 4690, 3562, 5608, 7166, 4703},  
{ 1033,  736, 2741, 3777, 4008,  332, 3323, 6332, 2286, 6481, 4672, 6634,  435, 26, 1918, 1592, 5483, 6423, 5277, 7933},  
{ 6148, 6132, 4446, 6532, 4771, 7156, 3313,  760,  877, 2818,  779, 3167, 1402, 3470, 2982, 4261, 7579, 3321,  853, 4823},  
{ 5842,  569,  70, 1963, 4363, 3105, 1360, 3196,  72, 1471,  766, 7990, 2751, 7373, 6757, 4858, 7191, 7540, 3620, 3235},  
{ 2212, 4341, 1127,  270, 7774, 3125, 2723,  967, 2948, 7147, 7685, 3559, 2813,   3,  515, 5447, 2574, 1334, 6391, 7169},  
{ 5573, 5533, 5081, 6197, 5303, 5718, 1915,  583, 7520,  690,  446, 3191, 4422, 1304, 6788,  969, 6271, 2192, 5349, 6974},  
{ 2786, 3374, 5935, 5155, 1962, 7618, 5632, 4015, 1175, 1500, 6249, 5140, 1670, 3886, 2766, 6957,  16, 7068, 2767, 7218},  
{ 2318, 7429, 6491, 4962, 7431, 7653, 1790, 1482, 5424, 6734, 1687, 5261, 4233,  997, 7257, 2821, 3866, 1352, 1838, 6733},  
{ 3949, 3795, 1555, 5278, 6161, 7329, 5209, 4647, 5631, 7575, 3961,  292, 6260, 7484, 7337, 4704,  206, 2757,  678, 2785},  
{ 6406, 2709, 4512, 5425, 5990, 2793, 4181, 8095, 5783, 7950, 6836, 4130, 4936, 4569, 2579,  32, 6569, 6257, 5045, 7614},  
{ 3444, 1984,  765, 7683, 2969, 4444, 4267, 2729, 3650, 5479,  925, 6506, 2288, 7687, 4469,  813, 7197, 6350, 6849, 4251},  
{ 2472,  464, 7226, 3329, 1148,  981, 6061, 3663, 4814, 6837, 3388, 4392, 7421, 3153,  100, 3798, 3726, 5491, 5186, 2471},  
{  642, 3793, 4200, 4856, 1272, 3319, 7695,  65, 4884, 4541, 7637, 7844, 5073, 5861, 5880, 4439, 3813, 5006, 6247, 5952},  
{ 7277, 2852, 4739, 1504, 6229, 1849, 4005, 6359,  507, 4189, 3420, 5476, 3396, 5736, 2666, 6713, 4973, 4294, 6492, 3766},  
{ 2508,  333, 1716, 4987, 2870, 3004,  797, 3241, 8019, 4463, 2386,  350, 5832, 1942, 3833, 6414, 4276, 1081, 2859, 5206},  
{ 2431, 4479, 4815, 5765, 6574, 6346, 5728, 3895,  541, 1689, 1722, 4070, 5702, 5831, 2314, 2114, 5704, 3231, 2939, 5149}};
matrix B1 ={ { 6545, 1875, 6820, 3195, 3815, 3481, 6269,  434, 2809, 4902, 4148, 2398, 5370, 6433, 4292, 7752, 3883, 8081, 2018, 2718},  
{ 7180,  249, 2183, 4976, 2589, 5401, 6342, 6147, 6653, 1246, 4193, 3917, 6848, 4253, 5973, 5863, 7971, 5192, 1649, 4669},  
{ 4916, 2470, 2446, 7831, 7953,  99, 6523, 4278, 5547, 7819, 6187, 6785, 5074, 5452, 6541, 7082, 2199, 2904, 3124, 2369},  
{  486, 5220, 5358, 6445, 7025, 4319, 5597, 1460, 5290, 6437,  581, 1309, 4549, 6629,  215, 4612, 5095, 6777, 7836, 4117},  
{ 6554, 6268, 6645, 2452, 7047, 6772, 2333, 8004, 1514, 4315, 6568,  632, 5827, 2355, 2467, 6451, 4433, 8032, 3549,  64},  
{ 3064, 4050, 2872, 2034, 5914,  171, 2295, 2323, 3504, 7660, 3432, 4048, 5347, 6543, 7643, 6582, 6641,  324, 4994, 6264},  
{ 4244, 8001, 4572, 3685, 6397, 4686, 2091, 7472,  325, 2220,  692, 5265, 4478, 7352, 6419,  542, 3593,  790, 4296, 4640},  
{ 1300, 4943, 5707, 3653, 7608, 4103, 4595, 5173, 3081, 6662, 1367, 4260, 1419, 5312, 8053, 4955, 1028, 7440, 4489,  252},  
{ 1233, 2941, 2878, 2282, 4934, 4980, 5271, 1532,  985,  404, 5976, 1600, 7470, 3003, 2680, 2101, 2396, 5434,  183, 5199},  
{  218, 6626, 4071, 1008,  24,  953, 6401, 4379, 6892, 5732, 3849, 7483,  248, 3245, 5345, 5779, 5946, 3502, 4390, 3268},  
{ 3759, 4677, 7887, 8002, 1023, 5001, 6563, 2084, 3179, 5619, 3534, 5595, 7888, 3192,  318,  403, 6443,  885, 1391, 3219},  
{ 5241,  755, 6642, 2695, 4821, 2276, 1692, 6614, 1147, 6817, 5866, 2803, 1035, 7114, 4434, 2312, 2661, 6065, 3490, 2456},  
{ 4725, 3879, 3888, 1620, 7896, 6063, 5407, 5108,  934, 7140, 1243, 6503, 4699, 6812, 6378, 6165, 5237, 6108,  169, 6578},  
{ 4179, 7585, 6429, 1955, 5031, 3938, 4208, 5830, 4492, 2070, 3072,  545, 7509, 4150, 4307, 8083, 1001, 3182,  613, 6060},  
{ 5730, 6967,  711,  604, 3538, 5948, 6458, 2826, 6155, 1786, 3737, 1009, 6470,  728,  801, 1672, 4993,  957, 5281, 5640},  
{  492, 1154, 2139, 3673, 2811, 1630, 5351, 3452, 7512,  964,  842, 2932, 6758, 1415, 3370, 1220, 3683, 5114, 1085, 8040},  
{ 6364, 5085, 7680, 4762,  634, 7273, 4535, 1351, 4996,  592, 3095, 4968, 1774, 1570,  490, 5812, 4234, 4488,  306, 6297},  
{ 1556, 2254, 4904,  423, 2150, 4183, 6345, 7393,  638, 3924, 1050, 5043, 6646, 4553,  421, 6341, 7655, 2326,  328, 8091},  
{ 7405, 7087, 2605,  819, 5077, 4482, 1993,  991, 3678, 7944, 1363,  388, 6306, 1728, 8090, 1194, 1092, 7713,  820, 6663}, 
{ 92, 5693, 6595, 2509, 1039, 1539, 2345, 3931, 2563, 1264, 1116, 7441, 2897, 6328, 5899, 4840, 3446, 4551, 4035, 3180}};
matrix A2 ={  { 6880, 7946, 7759, 3681, 4698, 5047, 6177, 1494, 6102, 5472, 1605, 4476, 2194, 5572, 6082, 3348, 7577, 8031, 4281, 3345},  
{ 5359, 6278, 5382, 1940,  687, 2585, 1426, 1797, 2090, 4724, 3699, 2478, 1454, 4026, 3829, 2890, 5980, 5565, 7652, 5492},  
{  369,  0, 7999, 3554, 7800, 5105, 1809, 7856, 4701, 6099,  320, 7650, 4868, 7740, 3349, 1865, 6402, 1373,  189, 7003},  
{  103, 2413, 4584, 4401, 5250, 6235, 3590, 2568, 3745, 7612,  380, 4101, 1117, 97, 2249, 3352, 6019, 1961, 5093, 6442},  
{ 3098,  178, 6206, 3199, 3181,  221, 7517, 5187, 6107, 1898, 6141,  714, 7791, 3606, 1763, 4690, 3562, 5608, 7166, 4703},  
{ 1033,  736, 2741, 3777, 4008,  332, 3323, 6332, 2286, 6481, 4672, 6634,  435, 26, 1918, 1592, 5483, 6423, 5277, 7933},  
{ 6148, 6132, 4446, 6532, 4771, 7156, 3313,  760,  877, 2818,  779, 3167, 1402, 3470, 2982, 4261, 7579, 3321,  853, 4823},  
{ 5842,  569,  70, 1963, 4363, 3105, 1360, 3196,  72, 1471,  766, 7990, 2751, 7373, 6757, 4858, 7191, 7540, 3620, 3235},  
{ 2212, 4341, 1127,  270, 7774, 3125, 2723,  967, 2948, 7147, 7685, 3559, 2813,   3,  515, 5447, 2574, 1334, 6391, 7169},  
{ 5573, 5533, 5081, 6197, 5303, 5718, 1915,  583, 7520,  690,  446, 3191, 4422, 1304, 6788,  969, 6271, 2192, 5349, 6974},  
{ 2786, 3374, 5935, 5155, 1962, 7618, 5632, 4015, 1175, 1500, 6249, 5140, 1670, 3886, 2766, 6957,  16, 7068, 2767, 7218},  
{ 2318, 7429, 6491, 4962, 7431, 7653, 1790, 1482, 5424, 6734, 1687, 5261, 4233,  997, 7257, 2821, 3866, 1352, 1838, 6733},  
{ 3949, 3795, 1555, 5278, 6161, 7329, 5209, 4647, 5631, 7575, 3961,  292, 6260, 7484, 7337, 4704,  206, 2757,  678, 2785},  
{ 6406, 2709, 4512, 5425, 5990, 2793, 4181, 8095, 5783, 7950, 6836, 4130, 4936, 4569, 2579,  32, 6569, 6257, 5045, 7614},  
{ 3444, 1984,  765, 7683, 2969, 4444, 4267, 2729, 3650, 5479,  925, 6506, 2288, 7687, 4469,  813, 7197, 6350, 6849, 4251},  
{ 2472,  464, 7226, 3329, 1148,  981, 6061, 3663, 4814, 6837, 3388, 4392, 7421, 3153,  100, 3798, 3726, 5491, 5186, 2471},  
{  642, 3793, 4200, 4856, 1272, 3319, 7695,  65, 4884, 4541, 7637, 7844, 5073, 5861, 5880, 4439, 3813, 5006, 6247, 5952},  
{ 7277, 2852, 4739, 1504, 6229, 1849, 4005, 6359,  507, 4189, 3420, 5476, 3396, 5736, 2666, 6713, 4973, 4294, 6492, 3766},  
{ 2508,  333, 1716, 4987, 2870, 3004,  797, 3241, 8019, 4463, 2386,  350, 5832, 1942, 3833, 6414, 4276, 1081, 2859, 5206},  
{ 2431, 4479, 4815, 5765, 6574, 6346, 5728, 3895,  541, 1689, 1722, 4070, 5702, 5831, 2314, 2114, 5704, 3231, 2939, 5149}};
matrix B2 ={ { 6545, 1875, 6820, 3195, 3815, 3481, 6269,  434, 2809, 4902, 4148, 2398, 5370, 6433, 4292, 7752, 3883, 8081, 2018, 2718},  
{ 7180,  249, 2183, 4976, 2589, 5401, 6342, 6147, 6653, 1246, 4193, 3917, 6848, 4253, 5973, 5863, 7971, 5192, 1649, 4669},  
{ 4916, 2470, 2446, 7831, 7953,  99, 6523, 4278, 5547, 7819, 6187, 6785, 5074, 5452, 6541, 7082, 2199, 2904, 3124, 2369},  
{  486, 5220, 5358, 6445, 7025, 4319, 5597, 1460, 5290, 6437,  581, 1309, 4549, 6629,  215, 4612, 5095, 6777, 7836, 4117},  
{ 6554, 6268, 6645, 2452, 7047, 6772, 2333, 8004, 1514, 4315, 6568,  632, 5827, 2355, 2467, 6451, 4433, 8032, 3549,  64},  
{ 3064, 4050, 2872, 2034, 5914,  171, 2295, 2323, 3504, 7660, 3432, 4048, 5347, 6543, 7643, 6582, 6641,  324, 4994, 6264},  
{ 4244, 8001, 4572, 3685, 6397, 4686, 2091, 7472,  325, 2220,  692, 5265, 4478, 7352, 6419,  542, 3593,  790, 4296, 4640},  
{ 1300, 4943, 5707, 3653, 7608, 4103, 4595, 5173, 3081, 6662, 1367, 4260, 1419, 5312, 8053, 4955, 1028, 7440, 4489,  252},  
{ 1233, 2941, 2878, 2282, 4934, 4980, 5271, 1532,  985,  404, 5976, 1600, 7470, 3003, 2680, 2101, 2396, 5434,  183, 5199},  
{  218, 6626, 4071, 1008,  24,  953, 6401, 4379, 6892, 5732, 3849, 7483,  248, 3245, 5345, 5779, 5946, 3502, 4390, 3268},  
{ 3759, 4677, 7887, 8002, 1023, 5001, 6563, 2084, 3179, 5619, 3534, 5595, 7888, 3192,  318,  403, 6443,  885, 1391, 3219},  
{ 5241,  755, 6642, 2695, 4821, 2276, 1692, 6614, 1147, 6817, 5866, 2803, 1035, 7114, 4434, 2312, 2661, 6065, 3490, 2456},  
{ 4725, 3879, 3888, 1620, 7896, 6063, 5407, 5108,  934, 7140, 1243, 6503, 4699, 6812, 6378, 6165, 5237, 6108,  169, 6578},  
{ 4179, 7585, 6429, 1955, 5031, 3938, 4208, 5830, 4492, 2070, 3072,  545, 7509, 4150, 4307, 8083, 1001, 3182,  613, 6060},  
{ 5730, 6967,  711,  604, 3538, 5948, 6458, 2826, 6155, 1786, 3737, 1009, 6470,  728,  801, 1672, 4993,  957, 5281, 5640},  
{  492, 1154, 2139, 3673, 2811, 1630, 5351, 3452, 7512,  964,  842, 2932, 6758, 1415, 3370, 1220, 3683, 5114, 1085, 8040},  
{ 6364, 5085, 7680, 4762,  634, 7273, 4535, 1351, 4996,  592, 3095, 4968, 1774, 1570,  490, 5812, 4234, 4488,  306, 6297},  
{ 1556, 2254, 4904,  423, 2150, 4183, 6345, 7393,  638, 3924, 1050, 5043, 6646, 4553,  421, 6341, 7655, 2326,  328, 8091},  
{ 7405, 7087, 2605,  819, 5077, 4482, 1993,  991, 3678, 7944, 1363,  388, 6306, 1728, 8090, 1194, 1092, 7713,  820, 6663}, 
{ 92, 5693, 6595, 2509, 1039, 1539, 2345, 3931, 2563, 1264, 1116, 7441, 2897, 6328, 5899, 4840, 3446, 4551, 4035, 3180}};
matrix Res1, Res2;
void error(void){
	printf("ERROR");
}
main()

{
	//inicio BB0
	//report_start();

	//base_test();
	int Outer0, Inner0, Index0, Outer1, Inner1, Index1;
	int Code = 0;
	for (Outer0 = Outer1 = 0; Outer0 < UPPERLIMIT; Outer0++)
	{
		if(Outer0!=Outer1) error();
		//inicio BB1
		for (Inner0 = Inner1 = 0; Inner0 < UPPERLIMIT; Inner0++)
		{
			if(Inner0!=Inner1) error();
			Res1 [Outer0][Inner0] = 0;
			Res2 [Outer0][Inner0] = 0;
			//inicio BB2
			for (Index0 = Index1 = 0; Index0 < UPPERLIMIT; Index0++)
			{
				
				
				if(Index0!=Index1) error();
				if(Outer0!=Outer1) error();
				if(Inner0!=Inner1) error();
				if(A1[Outer0][Index0]!=A2[Outer0][Index0]) error();
				if(B1[Outer0][Index0]!=B2[Outer0][Index0]) error();
				
				
				Res1[Outer0][Inner0]  +=
					A1[Outer0][Index0] * B1[Index0][Inner0];
				Res2[Outer0][Inner0]  +=
					A2[Outer0][Index0] * B2[Index0][Inner0];
				Index1++;
				printf("Res: %d",Res2[Outer0][Inner0]);
			}
			Inner1++;
       }
	   Outer1++;
	}


	//report_end();
}


