      SUBROUTINE VRCINP(NBVRCM, IND, INSTAM,INSTAP )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 11/06/2012   AUTEUR PROIX J-M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY  
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY  
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR     
C (AT YOUR OPTION) ANY LATER VERSION.                                   
C                                                                       
C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT   
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF            
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU      
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.                              
C                                                                       
C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE     
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,         
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C RESPONSABLE VABHHTS J.PELLET
      IMPLICIT   NONE
      INTEGER NBVRCM,IND
      REAL*8 INSTAM,INSTAP
C ======================================================================
C   BUT : FABRIQUER LE CHAMP DE VARIABLES DE COMMANDE CORRESPONDANT A
C         UN INSTANT DONNE POUR CALC_POINT_MAT / OP0033
C   ARGUMENTS :
C   IND      (I)   IN  : 0 => IACTIF=0 (FIN DE OP0033)
C   IND      (I)   IN  : 1 => IACTIF=1 INITIALISATIONS (DEBUT OP0033)
C   IND      (I)   IN  : 2 => INTERPOLATION EN COURS DE OP0033
C   INSTAM   (R)   IN  : VALEUR DE L'INSTANT -
C   INSTAP   (R)   IN  : VALEUR DE L'INSTANT +
C ----------------------------------------------------------------------
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------

      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      INTEGER NBOCC,IARG,IER,N1,IOCC
      CHARACTER*19 TVCNOM,TVCFON,TVCVAL
      INTEGER NUTE,JNBELR,JNOELR,IACTIF,JPNLFP,JNOLFP,NBLFPG
      COMMON /CAII11/NUTE,JNBELR,JNOELR,IACTIF,JPNLFP,JNOLFP,NBLFPG
      INTEGER JVCFON,JVCVAL
      COMMON /CAII33/JVCFON,JVCVAL
      INTEGER NBCVRC,JVCNOM
      COMMON /CAII14/NBCVRC,JVCNOM
      DATA TVCNOM/'&&OP0033.TVCNOM'/
      DATA TVCFON/'&&OP0033.TVCFON'/
      DATA TVCVAL/'&&OP0033.TVCVAL'/
C ----------------------------------------------------------------------

      CALL JEMARQ()
      
      IF (IND.EQ.1) THEN
         IACTIF=2      
         CALL GETFAC('AFFE_VARC',NBOCC)
         NBCVRC=NBOCC
         CALL ASSERT(NBCVRC.LE.NBVRCM)
         
         IF (NBCVRC.EQ.0) THEN
            GOTO 9999
         ENDIF
         
         CALL WKVECT(TVCNOM,'V V K8',NBCVRC,JVCNOM)
         CALL WKVECT(TVCFON,'V V K8',NBCVRC,JVCFON)
         CALL WKVECT(TVCVAL,'V V R',3*NBCVRC,JVCVAL)
 
         DO 10 IOCC=1,NBOCC
C           ON STOCKE LES NOMS PUIS LES FONCTIONS 
            CALL GETVTX('AFFE_VARC','NOM_VARC', IOCC,IARG,1,
     &                  ZK8(JVCNOM-1+IOCC),N1)
            CALL GETVID('AFFE_VARC','VALE_FONC',IOCC,IARG,1,
     &                  ZK8(JVCFON-1+IOCC),N1)
C           AJOUTER LES FONCTIONS DEVRIVANT LES PHASES METALLURGIQUES
            CALL GETVR8('AFFE_VARC','VALE_REF', IOCC,IARG,1,
     &                   ZR(JVCVAL-1+3*(IOCC-1)+3),N1)
 
  10     CONTINUE
  
      ELSEIF (IND.EQ.0) THEN
         IACTIF=0
       
      ELSEIF (IND.EQ.2) THEN
         IACTIF=2      
C        EVALUATION DES FONCTIONS
         DO 20 IOCC=1,NBCVRC
            CALL FOINTE ('F',ZK8(JVCFON-1+IOCC),
     &                    1,'INST',INSTAM,ZR(JVCVAL-1+3*(IOCC-1)+1),IER)
            CALL FOINTE ('F',ZK8(JVCFON-1+IOCC),
     &                    1,'INST',INSTAP,ZR(JVCVAL-1+3*(IOCC-1)+2),IER)
  20     CONTINUE

      ENDIF       

9999  CONTINUE
      CALL JEDEMA()
      END
