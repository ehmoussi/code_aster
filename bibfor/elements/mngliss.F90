subroutine mngliss(tau1  ,tau2  ,djeut,kappa ,taujeu1, taujeu2, &
                  dnepmait1,dnepmait2,ndim )


!
! ======================================================================
! COPYRIGHT (C) 1991 - 2015  EDF R&D                  WWW.CODE-ASTER.ORG
! THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
! IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
! THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
! (AT YOUR OPTION) ANY LATER VERSION.
!
! THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
! WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
! MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
! GENERAL PUBLIC LICENSE FOR MORE DETAILS.
!
! YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
! ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
!   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
! ======================================================================
! person_in_charge: mickael.abbas at edf.fr
!


    implicit     none
    
    
#include "asterfort/assert.h" 
    
    integer :: ndim,  nnm

    integer :: iresog,granglis
    
    

    real(kind=8) :: geomam(9, 3),depmam(9, 3)



    real(kind=8) :: jeu,djeu(3),djeut(3),mprojt(3,3)
    

    real(kind=8) :: ddffm(3,9),dffm(2, 9)
    
    real(kind=8) :: norm(3), tau1(3), tau2(3)
    
    real(kind=8) :: mprt1n(3, 3), mprt2n(3, 3)
    real(kind=8) :: mprt11(3, 3), mprt21(3, 3), mprt22(3, 3)
       
    real(kind=8) :: gene11(3, 3), gene21(3, 3),gene22(3,3)
    
    real(kind=8) :: kappa(2,2),a(2,2),h(2,2),ha(2,2),hah(2,2)
    
    real(kind=8) :: vech1(3),vech2(3)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
!
! CALCUL DES MATRICES DE PROJECTION POUR NEWTON GENERALISE
!
! ----------------------------------------------------------------------
! IN  NDIM   : DIMENSION DE LA MAILLE DE CONTACT
! IN  NNE    : NOMBRE DE NOEUDS DE LA MAILLE ESCLAVE
! IN  NNM    : NOMBRE DE NOEUDS DE LA MAILLE MAITRE
! IN  IRESOG : ALGO. DE RESOLUTION POUR LA GEOMETRIE
!              0 - POINT FIXE
!              1 - NEWTON
! IN FFE    : FONCTIONS DE FORMES DEPL. ESCL.
! IN FFM    : FONCTIONS DE FORMES DEPL. MAIT.
! IN DFFM   : DERIVEES PREMIERE DES FONCTIONS DE FORME MAITRES 
! IN DDFFM  : DERIVEES SECONDES DES FONCTIONS DE FORME MAITRES
! IN GEOMAE : GEOMETRIE ACTUALISEE SUR NOEUDS ESCLAVES
! IN GEOMAM : GEOMETRIE ACTUALISEE SUR NOEUDS MAITRES
! IN tau1   : PREMIER VECTEUR TANGENT
! IN tau2   : SECOND VECTEUR TANGENT
! IN NORM   : NORMALE INTERIEURE
! IN GEOME  : COORDONNEES ACTUALISEES DU POINT DE CONTACT
! IN GEOMM  : COORDONNEES ACTUALISEES DU PROJETE DU POINT DE CONTACT

! -----------------------------------------------------------------------
!     MATRICES ISSUES DE LA GEOMETRIE DIFFERENTIELLE POUR NEWTON GENE
! -----------------------------------------------------------------------
! OUT MPRT11 : MATRICE DE PROJECTION TANGENTE DANS LA DIRECTION 1
! OUT MPRT11 = tau1*TRANSPOSE(tau1)(matrice 3*3)
!
! OUT MPRT12 : MATRICE DE PROJECTION TANGENTE DANS LA DIRECTION 1/2
! OUT MPRT12 = tau1*TRANSPOSE(tau2)(matrice 3*3)
!
! OUT MPRT12 : MATRICE DE PROJECTION TANGENTE DANS LA DIRECTION 2
! OUT MPRT12 = tau2*TRANSPOSE(tau2)(matrice 3*3)
!
! OUT GENE11 : MATRICE EULERIENNE DUE A LA REGULARITE DE LA SURFACE MAITRE
! OUT          DDGEOMM(1,1)/NORMALE  (matrice 3*3)
!
! OUT GENE21 : MATRICE EULERIENNE DUE A LA REGULARITE DE LA SURFACE MAITRE
! OUT          DDGEOMM(2,1)/NORMALE  (matrice 3*3) 
!
! OUT GENE22 : MATRICE EULERIENNE DUE A LA REGULARITE DE LA SURFACE MAITRE
! OUT          DDGEOMM(2,2)/NORMALE  (matrice 3*3)
!
! OUT KAPPA  : MATRICE DE SCALAIRES LIEES A LA CINEMATIQUE DU GLISSEMENT
! OUT KAPPA(i,j) = INVERSE[tau_i.tau_j-JEU*(ddFFM*geomm)](matrice 2*2)
!
! OUT H : MATRICE DE SCALAIRES EULERIENNE DUE A LA REGULARITE DE LA SURFACE MAITRE
! OUT H(i,j) = JEU*{[DDGEOMM(i,j)].n} (matrice 2*2)
!
! OUT A : MATRICE DE SCALAIRES DUE AU TENSEUR DE WEINTGARTEN
! OUT A(i,j) = [tau_i.tau_j] (matrice 2*2)
! 
! OUT HA  = H/A   (matrice 2*2)
! OUT HAH = HA/H  (matrice 2*2)
! 
! OUT VECH_i = KAPPA(i,m)*tau_m
!
! OUT IRESOG EST REMIS AUTOMATIQUEMENT A ZERO SI DET(KAPPA) = 0 
!              0 - POINT FIXE
!              1 - NEWTON
! ----------------------------------------------------------------------

!
! ----------------------------------------------------------------------
!
    integer :: i, j, inom,idim
    real(kind=8) :: ddgeo1(3),ddgeo2(3),ddgeo3(3),detkap,ddepmait1(3),ddepmait2(3)
    real(kind=8) :: dnepmait1,dnepmait2,taujeu1,taujeu2
    real(kind=8) :: djeung(3),dxi1,dxi2

    djeut = 0.
    dxi1  = 0.
    dxi2  = 0.

    if (ndim .eq. 2) then         
        dxi1=kappa(1,1)*(taujeu1 + dnepmait1)
        do i = 1, ndim
                djeut(i) = tau1(i)*dxi1
        end do

    else if (ndim.eq.3) then
      dxi1=kappa(1,1)*(taujeu1 + dnepmait1)+&
          kappa(1,2)*(taujeu2 +  dnepmait2)
          
      dxi2=kappa(2,1)*(taujeu1 +  dnepmait1)+&
          kappa(2,2)*(taujeu2 + dnepmait2)

      do idim =1,ndim
            djeut(idim)= (tau1(idim)*dxi1+tau2(idim)*dxi2)         
      end do
    
    else 
        ASSERT(.false.)
      
    endif
!     write (6,*) "djeut",djeut
!     write (6,*) "taujeu1",taujeu1
!     write (6,*) "dnepmait1",dnepmait1
!     write (6,*) "dxi1",dxi1
!     write (6,*) "kappa11",kappa(1,1)




end subroutine
