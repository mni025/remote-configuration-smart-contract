/*
 * rsa.h
 *
 *  Created on: Sep 29, 2020
 *      Author: Nazmul
 */

#ifndef SRC_RSA_H_
#define SRC_RSA_H_

long raiseto_mod(long a, long b, long c);

// additional funcitons for RSA
long* rsa_decrypt(long* ciphertext_list, long* key, int length) {
	long* plaintext_list;
	plaintext_list = new long[length];
	for(int i = 0; i < length; ++i) {
	  plaintext_list[i] = raiseto_mod(ciphertext_list[i], key[1], key[0]);
    }
	return plaintext_list;
}

long raiseto_mod(long a, long b, long c) {
  long temp = 1;
  for (long i = 0; i < b; ++i) {
    temp = (temp * a) % c;
  }
  return temp;
}


#endif /* SRC_RSA_H_ */
