import re
import argparse
from concurrent import futures
import time
import os
from title_maker_pro.word_generator import WordGenerator
import logging

logging.disable(logging.CRITICAL);

def main(args):

    word_generator = WordGenerator(
        device="cpu",
        forward_model_path=args.forward_model_path,
        inverse_model_path=args.inverse_model_path,
        blacklist_path=args.blacklist_path,
        quantize=True,
        is_urban=False,
    )
    urban_generator = None

    words = []
    while len(words) < 3:
      genWord = word_generator.generate_word()
      if genWord:
        word = re.sub('\W', '', genWord.word)
        if len(word) > 2:
          words.append(word)

    print("\n[WORD]"+" ".join(words))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--forward-model-path", help="Model path for (Word -> Definition)", type=str, required=True)
    parser.add_argument("--inverse-model-path", help="Model path for (Definition -> Word)", type=str, required=True)
    parser.add_argument(
        "--blacklist-path", help="Blacklist path for word generation", type=str, required=True,
    )
    args = parser.parse_args()
    main(args)