FROM ubuntu
ADD ./piecebypiece.sh /usr/src/piecebypiece.sh
RUN chmod +x /usr/src/piecebypiece.sh
CMD ["/usr/src/piecebypiece.sh"]
