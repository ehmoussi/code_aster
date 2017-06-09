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

subroutine casonl(char, ligrmo, noma, ndim)
!
    implicit none
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/alcart.h"
#include "asterfort/char_affe_neum.h"
#include "asterfort/getvid.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nocart.h"
#include "asterfort/reliem.h"
#include "asterfort/vetyma.h"
!
    integer :: ndim
    character(len=8) :: char, noma
    character(len=*) :: ligrmo
!
! ----------------------------------------------------------------------
!                   SOURCE THERMIQUE NON LINEAIRE
!
!-----------------------------------------------------------------------
!  STOCKAGE DES SOURCES DANS UNE CARTE ALLOUEE SUR LE LIGREL DU MODELE
!-----------------------------------------------------------------------
!      CHAR   : NOM UTILISATEUR DU RESULTAT DE CHARGE
!      LIGRMO : NOM DU LIGREL DE MODELE
!      NOMA   : NOM DU MAILLAGE
!      NDIM   : DIMENSION DU PROBLEME (2D/3D) POUR FILTRER LES MAILLES
!-----------------------------------------------------------------------
    integer :: nsour, jvalv,  n1, ncmp, iocc
    character(len=16) :: motclf
    character(len=19) :: carte
    character(len=19) :: cartes(1)
    integer :: ncmps(1)
    character(len=8), pointer :: vncmp(:) => null()
!
! ----------------------------------------------------------------------
    call jemarq()
!
    motclf = 'SOUR_NL'
    ncmp = 1
    call getfac(motclf, nsour)
!
    carte = char//'.CHTH.SOUNL'
    call alcart('G', carte, noma, 'SOUR_F')
    call jeveuo(carte//'.NCMP', 'E', vk8=vncmp)
    call jeveuo(carte//'.VALV', 'E', jvalv)
    vncmp(1) = 'SOUR'
!
!
! --- DEFAUT: STOCKAGE D'UNE SOURCE NULLE SUR TOUT LE MAILLAGE
!
    zk8(jvalv) = '&FOZERO'
    call nocart(carte, 1, ncmp)
!
!
! --- STOCKAGE DES FONCTIONS SOURCES DANS LA CARTE
!
    do iocc = 1, nsour
        call getvid(motclf, 'SOUR', iocc=iocc, scal=zk8(jvalv), nbret=n1)
!
        cartes(1) = carte
        ncmps(1) = ncmp
        call char_affe_neum(noma, ndim, motclf, iocc, 1,&
                            cartes, ncmps)
    end do
!
    call jedema()
end subroutine
