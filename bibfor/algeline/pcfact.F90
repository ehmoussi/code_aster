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

subroutine pcfact(matas, nequ, in, ip, ac,&
                  prc, vect, epsi)
! aslint: disable=W1304, C1513
    implicit none
#include "jeveux.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/rgndas.h"
!-----------------------------------------------------------------------
!  FONCTION  :  CREATION D'UNE MATRICE DE PRECONDITIONNEMENT PRC
!     PAR LDLT INCOMPLET SUR LA MATRICE MAT STOCKEE SOUS FORME MORSE
!     EN NE STOCKANT SOUS FORME MORSE DANS LA MATRICE PRC QUE LES
!     TERMES OCCUPANT LA MEME POSITION QUE DANS LA MATRICE DE DEPART
!
!     ON STOCKE L ' INVERSE DE LA DIAGONALE   ( VOIR S-P GCLDM1 )
!
!  REMARQUE: A L'APPEL AC ET PRC PEUVENT ETRE CONFONDUS
!-----------------------------------------------------------------------
    integer :: nequ
    real(kind=8) :: ac(*), prc(*), vect(nequ)
    character(len=19) :: matas
    integer :: in(nequ)
    integer(kind=4) :: ip(*)
    integer :: vali
    integer :: i, j, jdeb, jfin, jj, kdeb, kfin
    integer :: ki, kk, jrefa
    character(len=24) numedd
    character(len=8) name_node, name_cmp, valk(2)
    real(kind=8) :: cumul, epsi
!-----------------------------------------------------------------------
    do j = 1, nequ
        vect(j) = 0.d0
    enddo

!   -- PREMIER TERME DIAGONAL...ON STOCKE LES INVERSES
    prc(1) = 1.d0/ac(1)

!   -- BOUCLE SUR LES LIGNES DE LA MATRICE
    do i = 2, nequ
        jfin = in(i)
        jdeb = in(i-1) + 1
!       -- TEST SI LIGNE VIDE
        if (jdeb .le. jfin) then
!           -- TEST SI LIGNE(I)=SEUL TERME DIAG
            if (jdeb .eq. jfin) then
                cumul = ac(jfin)
            else
!               -- PREMIER TERME DE LA LIGNE
                prc(jdeb) = ac(jdeb)
!                ALTERATION DU VECTEUR AUXILIAIRE POUR PROD-SCAL CREUX
                vect(ip(jdeb)) = ac(jdeb)
!               -- TERMES COURANTS DE LA LIGNE
                do jj = jdeb + 1, jfin - 1
                    cumul = ac(jj)
                    j = ip(jj)
                    kfin = in(j)
                    kdeb = in(j-1) + 1
                    do kk = kdeb, kfin - 1
                        cumul = cumul - prc(kk)*vect(ip(kk))
                    enddo
                    prc(jj) = cumul
!                   -- ALTERATION DU VECTEUR AUXILIAIRE POUR PROD-SCAL CREUX
                    vect(ip(jj)) = cumul
                enddo
!               -- TERME DIAGONAL
                cumul = ac(jfin)
!DIR$ IVDEP
                do ki = jdeb, jfin - 1
                    prc(ki) = prc(ki)*prc(in(ip(ki)))
                    cumul = cumul - prc(ki)*vect(ip(ki))
!                   REMISE A 0 PARTIELLE DU VECTEUR AUXILIAIRE
                    vect(ip(ki)) = 0.d0
                enddo
            endif
!           -- TEST DE SINGULARITE
            if (abs(cumul) .lt. epsi) then
                vali = i
                call jeveuo(matas//'.REFA', 'L', jrefa)
                numedd = zk24(jrefa+1)
                call rgndas(numedd, i, .false., name_nodez=name_node,&
                            name_cmpz=name_cmp)
                valk(1) = name_node
                valk(2) = name_cmp
                call utmess('F', 'ALGELINE4_58', nk = 2, valk=valk, si=vali)
            endif
            prc(jfin) = 1.d0/cumul
        endif
    enddo

end subroutine
