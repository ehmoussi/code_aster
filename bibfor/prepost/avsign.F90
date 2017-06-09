! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine avsign(nbvec, nbordr, vectn, vwork, tdisp,&
                  kwork, sommw, tspaq, i, jvsign)
! person_in_charge: van-xuan.tran at edf.fr
    implicit      none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    integer :: nbvec, nbordr, tdisp, kwork, sommw, tspaq, i
    real(kind=8) :: vectn(3*nbvec)
    real(kind=8) :: vwork(tdisp)
!    real(kind=8) ::vsign(nbvec*nbordr)
    integer ::jvsign
! ----------------------------------------------------------------------
! BUT: CALCULER LA CONTRAINTE NORMALE POUR TOUS LES VECTEURS NORMAUX
!      A TOUS LES NUMEROS D'ORDRE.
! ----------------------------------------------------------------------
! ARGUMENTS :
!  NBVEC  : IN   I  : NOMBRE DE VECTEURS NORMAUX.
!  NBORDR : IN   I  : NOMBRE DE NUMEROS D'ORDRE.
!  VECTN  : IN   R  : VECTEUR CONTENANT LES COMPOSANTES DES
!                     VECTEURS NORMAUX.
!  VWORK  : IN   R  : VECTEUR DE TRAVAIL CONTENANT
!                     L'HISTORIQUE DES TENSEURS DES CONTRAINTES
!                     ATTACHES A CHAQUE POINT DE GAUSS DES MAILLES
!                     DU <<PAQUET>> DE MAILLES.
!  TDISP  : IN   I  : TAILLE DU VECTEUR DE TRAVAIL.
!  KWORK  : IN   I  : KWORK = 0 ON TRAITE LA 1ERE MAILLE DU PAQUET
!                               MAILLES OU LE 1ER NOEUD DU PAQUET DE
!                               NOEUDS;
!                     KWORK = 1 ON TRAITE LA IEME (I>1) MAILLE DU PAQUET
!                               MAILLES OU LE IEME NOEUD DU PAQUET
!                               DE NOEUDS.
!  SOMMW  : IN   I  : SOMME DES POINTS DE GAUSS OU DES NOEUDS DES N
!                     MAILLES PRECEDANT LA MAILLE COURANTE.
!  TSPAQ  : IN   I  : TAILLE DU SOUS-PAQUET DU <<PAQUET>> DE MAILLES
!                     OU DE NOEUDS COURANT.
!  I      : IN   I  : IEME POINT DE GAUSS OU IEME NOEUD.
!  NOMCRI : IN  K16 : NOM DU CRITERE D'ENDOMMAGEMENT PAR FATIGUE.
!  JVSIGN  : OUT  I  : ADDRESS VECTEUR CONTENANT LES VALEURS DE LA CONTRAINTE
!                     NORMALE, POUR TOUS LES NUMEROS D'ORDRE
!                     DE CHAQUE VECTEUR NORMAL.
! ----------------------------------------------------------------------
    integer :: n, decal, ivect, iordr, adrs
    real(kind=8) :: nx, ny, nz
    real(kind=8) :: sixx, siyy, sizz, sixy, sixz, siyz, fx, fy, fz, norm
!     ------------------------------------------------------------------
!
!234567                                                              012
!
    call jemarq()
!
    n = 1
!       IF (( NOMCRI(1:16) .EQ. 'FATESOCI_MODI_AV' ) .OR.
!      &  FORDEF ) THEN
!          DECAL = 12
!       ELSE
!          DECAL = 6
!       ENDIF
    decal = 18
    do 10 ivect = 1, nbvec
        nx = vectn((ivect-1)*3 + 1)
        ny = vectn((ivect-1)*3 + 2)
        nz = vectn((ivect-1)*3 + 3)
!
        do 20 iordr = 1, nbordr
            adrs = (iordr-1)*tspaq + kwork*sommw*decal + (i-1)*decal
            sixx = vwork(adrs + 1)
            siyy = vwork(adrs + 2)
            sizz = vwork(adrs + 3)
            sixy = vwork(adrs + 4)
            sixz = vwork(adrs + 5)
            siyz = vwork(adrs + 6)
!
! CALCUL DE vect_F = [SIG].vect_n
            fx = sixx*nx + sixy*ny + sixz*nz
            fy = sixy*nx + siyy*ny + siyz*nz
            fz = sixz*nx + siyz*ny + sizz*nz
!
! CALCUL DE NORM = vect_F.vect_n
            norm = fx*nx + fy*ny + fz*nz
            zr(jvsign+n) = norm
            n = n + 1
20      continue
10  end do
!
    call jedema()
!
end subroutine
