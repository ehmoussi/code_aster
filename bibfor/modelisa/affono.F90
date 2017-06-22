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

subroutine affono(valr, valk, desc, prnm, nbcomp,&
                  fonree, nomn, ino, nsurch, forimp,&
                  valfor, valfof, motcle, verif, nbec)
    implicit none
!
!
#include "asterf_types.h"
#include "asterfort/exisdg.h"
#include "asterfort/utmess.h"
    integer :: prnm(1), nbcomp, desc, ino, nsurch, forimp(nbcomp)
    real(kind=8) :: valr(1), valfor(nbcomp)
    aster_logical :: verif
    character(len=4) :: fonree
    character(len=8) :: valk(1), nomn, valfof(nbcomp)
    character(len=16) :: motcle(nbcomp), valkk(2)
!
! BUT : * DETECTER ET PRENDRE EN COMPTE LES SURCHARGES DANS FORCE_NODALE
!        1 REMPLIR LES TABLEAUX DESCRIPTEUR DE FORCES IMPOSEES
!        2 COMPTER LE NOMBRE DE SURCHARGES DE FORCE_NODALE
!          POUR PERMETTE L'ALLOCATION DES CARTES A LA BONNE DIMENSION
!        3 EMET UN MESSAGE D'ALARME EN CAS DE SURCHARGE
!
! ARGUMENTS D'ENTREE:
!
!   PRNM   : DESCRIPTEUR GRANDEUR SUR LE NOEUD INO
!   NBCOMP : NOMBRE DE DDLS DANS FORCE_NODALE
!   FONREE : AFFE_CHAR_XXXX OU AFFE_CHAR_XXXX_F
!   NOMN   : NOM DU NOEUD INO OU EST EFFECTUEE L'AFFECTATION
!   INO    : NUMERO DU NOEUD OU EST EFFECTUEE L'AFFECTATION
!   FORIMP : INDICATEUR DE PRESENCE OU ABSENCE DE FORCE SUR CHAQUE DDL
!   VALFOR : VALEURS AFFECTEES SUR CHAQUE DDL (FONREE = 'REEL')
!   VALFOF : VALEURS AFFECTEES SUR CHAQUE DDL (FONREE = 'FONC')
!   MOTCLE : TABLEAU DES NOMS DES DDLS DANS FORCE_NODALE
!   VERIF  : BOOLEEN ( TRUE ---> VERIFICATION SI LE DDL AFFECTE
!                                EST PRESENT SUR LE NOEUD
!                      FALSE --> ON PASSE ET ON INCREMENTE LA SURCHARGE)
!   NBEC   : NOMBRE D'ENTIERS CODES REPRESENTANT LA GRANDEUR
!
! ARGUMENTS D'ENTREE MODIFIES:
!
!      VALR  : VALEURS DES DDLS DE FORCES  (FONREE = 'REEL')
!      VALK  : VALEURS DES DDLS DE FORCES  (FONREE = 'FONC')
!      DESC  : TABLEAU CONTENANT LE DESCRIPTEUR DES AFFECTATIONS
!              (CODES A PARTIR DU PREMIER BIT)
!     NSURCH : COMPTEUR DU NOMBRE DE SURCHARGES DANS FORCE_NODALE
!
!
!****************************************************************
!-----------------------------------------------------------------------
    integer :: iec, indigd, j, nbec, nsurc0
!-----------------------------------------------------------------------
    indigd = 0
    do 10 iec = 1, nbec
        if (prnm(iec) .ne. 0) then
            indigd = 1
            goto 20
        endif
 10 end do
    if (indigd .eq. 0) goto 9999
 20 continue
    nsurc0 = nsurch
    do 30 j = 1, nbcomp
        if (forimp(j) .ne. 0) then
            if (iand(desc,2**(j-1)) .eq. 0) then
!  VERIFICATION SUR LES 6 PREMIERS DDL : FX FY FZ MX MY MZ
                if (.not.exisdg(prnm,j) .and. j .le. 6) then
                    if (.not.verif) then
                        if (nsurc0 .eq. nsurch) nsurch = nsurch + 1
                    else
                        valkk (1) = motcle(j)
                        valkk (2) = nomn
                        call utmess('F', 'MODELISA8_27', nk=2, valk=valkk)
                    endif
                else
                    desc = ior(desc,2**(j-1))
                endif
            else
                if (nsurc0 .eq. nsurch) nsurch = nsurch + 1
                valkk (1) = motcle(j)
                valkk (2) = nomn
                call utmess('I', 'MODELISA8_28', nk=2, valk=valkk)
            endif
            if (fonree .eq. 'REEL') then
                valr(nbcomp*(ino-1)+j) = valfor(j)
            else if (fonree.eq.'FONC') then
                valk(nbcomp*(ino-1)+j) = valfof(j)
            endif
        endif
 30 end do
!
9999 continue
end subroutine
