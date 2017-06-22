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

subroutine decod2(rec, irec, ifield, itype, ilu,&
                  rlu, trouve)
    implicit none
#include "asterf_types.h"
#include "asterc/ismaem.h"
#include "asterc/r8vide.h"
#include "asterfort/lxliis.h"
#include "asterfort/lxlir8.h"
#include "asterfort/trfmot.h"
    character(len=*) :: rec(20)
    integer :: irec, ifield, itype, ilu
    real(kind=8) :: rlu
    aster_logical :: trouve
!
!
!    EXTRACTION DE L'ENREGISTREMENT IREC ET DU CHAMP IFIELD
!               DU NUMERO D'ORDRE OU DE L'INSTANT OU DE LA
!               FREQUENCE
!
! IN  : REC    : K80  : TABLEAU DE CARACTERES CONTENANT L'ENTETE DU
!                       DATASET
! IN  : IREC   : I    : NUMERO DE L'ENREGISTREMENT A TRAITER
! IN  : IFIELD : I    : NUMERO DU CHAMP A TRAITER
! IN  : ITYPE  : I    : TYPE DE VALEUR LUE (0:ENTIER, 1:REELLE)
! OUT : ILU    : I    : VALEUR ENTIERE LUE (NUMERO D'ORDRE)
! OUT : RLU    : I    : VALEUR REELLE LUE (INSTANT OU FREQUENCE)
! OUT : TROUVE : L    : .TRUE.  ON A TROUVE LA VALEUR ATTENDUE
!                       .FALSE. ON N A PAS TROUVE LA VALEUR ATTENDUE
!
!---------------------------------------------------------------------
    character(len=80) :: field
    integer :: ier
!
!- INITIALISATION
    trouve = .true.
    ilu=ismaem()
    rlu=r8vide()
!
!- SI IREC OU IFIELD INVALIDE : ON RETOURNE DES VALEURS VIDES :
    if ((irec.le.0) .or. (ifield.le.0)) then
        trouve=.false.
        goto 9999
    endif
!
!- RECHERCHE DU CHAMP A TRAITER
!
    call trfmot(rec(irec), field, ifield)
!
    if (itype .eq. 0) then
!
!- DECODAGE D'UN ENTIER ET VERIFICATION
!
        call lxliis(field, ilu, ier)
        if (ier .eq. 1) trouve = .false.
!
    else
!
!- DECODAGE D'UN REEL ET VERIFICATION
!
        call lxlir8(field, rlu, ier)
        if (ier .eq. 1) trouve = .false.
!
    endif
9999 continue
end subroutine
