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

subroutine ploint(vesto, modmec, chamno, num, i,&
                  vrai, model, veprj, modx, mody,&
                  modz)
    implicit none
!
! ROUTINE PROJETANT LA PRESSION ET LES DEPLACEMENTS SUR L'INTERFACE
!
! IN : MODMEC : NOM DU CONCEPT MODE_MECA
! IN : CHAMNO : CHAMNO DE DEPL_R
! IN : NUM : NUMEROTATION DES DDLS SUR MODELE INTERFACE
! IN: I : INDICE DE BOUCLES
! IN : VRAI : LOGICAL DISTINGUANT MODAL ET CHAMNO IMPOSE
! IN : MODEL : K2 :CHARACTER DISTINGUANT LE TYPE DE MODELE 2D OU 3D
! OUT :  VEPRJ : CHAMP DE PRESSION PROJETE
! OUT : MODX : CHAMP DES DEPLACEMENTS SUIVANT X
! OUT :  MODY : CHAMP DES DEPLACEMENTS SUIVANT Y
! OUT :  MODZ : CHAMP DES DEPLACEMENTS SUIVANT Z
!
!------------------------------------------------------------------
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/chnucn.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsexch.h"
    aster_logical :: vrai
    integer :: ipres, i, iret
    character(len=8) :: k8bid, tcorx(2), tcory(2), tcorz(2)
    character(len=*) :: modmec, chamno, model
    character(len=14) :: num
    character(len=19) :: vesto, modx, mody, modz, veprj
    character(len=24) :: nomcha, nocham
!-----------------------------------------------------------------
!
!-- PLONGEMENT DES VECTEURS PRESSIONS  POUR CHAQUE MODE SUR LE
!                          MODELE INTERFACE
!
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call jemarq()
    modz=' '
    veprj = 'VEPRJ'
    call chnucn(vesto, num, 0, k8bid, 'V',&
                veprj)
    call jeveuo(veprj//'.VALE', 'L', ipres)
!
!
!---------------- PLONGEMENT DES MODES OU CHAMNO
!-------------PAR COMPOSANTES SUR LE MODELE INTERFACE
!
    if (vrai) then
!
        call rsexch(' ', modmec, 'DEPL', i, nomcha,&
                    iret)
        nocham = nomcha
!
    else
!
        nocham = chamno
!
    endif
!
!----- PLONGEMENT DE LA COMPOSANTE DX QUI DEVIENT TEMPERATURE
!
    tcorx(1) = 'DX'
    tcorx(2) = 'TEMP'
    modx = 'MODX'
    call chnucn(nocham, num, 2, tcorx, 'V',&
                modx)
!
!----- PLONGEMENT DE LA COMPOSANTE DY QUI DEVIENT TEMPERATURE
!
    tcory(1) = 'DY'
    tcory(2) = 'TEMP'
    mody = 'MODY'
    call chnucn(nocham, num, 2, tcory, 'V',&
                mody)
!
!----- PLONGEMENT DE LA COMPOSANTE DZ QUI DEVIENT TEMPERATURE
!
    if (model .eq. '3D') then
        tcorz(1) = 'DZ'
        tcorz(2) = 'TEMP'
        modz = 'MODZ'
        call chnucn(nocham, num, 2, tcorz, 'V',&
                    modz)
    endif
!
    call jedema()
end subroutine
