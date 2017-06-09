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

subroutine sndbg(ifm, iclass, ival, rval, kval)
    implicit none
    integer :: ifm, iclass, ival
    real(kind=8) :: rval(*)
    character(len=*) :: kval
!     ------------------------------------------------------------------
!          ECRITURE DE CE QUE L'ON A TROUVE (NIVEAU SN)
!     ------------------------------------------------------------------
! IN  ICLASS   CLASSE  DE CE QUE L'ON A TROUVE
!     ------------------------------------------------------------------
!           -- TYPE -----    ---- INFORMATION --------------------------
!      -1   FIN DE FICHIER
!       0   ERREUR           CVAL DE TYPE CHARACTER*(*) DE LONGUEUR IVAL
!       1   ENTIER           IVAL DE TYPE INTEGER
!       2   REEL             RVAL(1) DE TYPE REAL*8
!       3   IDENTIFICATEUR   CVAL DE TYPE CHARACTER*(*) DE LONGUEUR IVAL
!       4   TEXTE            CVAL DE TYPE CHARACTER*(*) DE LONGUEUR IVAL
!       5   COMPLEXE         RVAL(1),RVAL(2)
!       6   BOOLEEN          IVAL  = 1 = VRAI , 0 = FAUX
!
!           SEPARATEUR       CVAL DE TYPE CHARACTER*(*) DE LONGUEUR 1
!       7   '('
!       8   ')'
!       9   ','
!      10   ':'
!      11   '='
!      12   ';'
!      13   SEPARATEUR INDEFINI
!     ROUTINE(S) UTILISEE(S) :
!         -
!     ROUTINE(S) FORTRAN     :
!         WRITE
!     ------------------------------------------------------------------
! FIN SNDBG
!     ------------------------------------------------------------------
!
    character(len=12) :: pgm
    character(len=80) :: cval
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    cval = kval
    pgm = ' <SNDBG >:  '
    write(ifm,'(1X,72(''-''))')
    if (iclass .eq. -1) then
        write(ifm,*) pgm,'EOF    : "FIN DE FICHIER"'
    else if (iclass.eq.0) then
        write(ifm,*) pgm,'ERREUR : "'//cval(:ival)//'"'
    else if (iclass.eq.1) then
        write(ifm,*) pgm,'ENTIER :', ival
    else if (iclass.eq.2) then
        write(ifm,*) pgm,'REEL   :', rval(1)
    else if (iclass.eq.3) then
        write(ifm,*) pgm,'IDENT  : "'//cval(:ival)//'"'
    else if (iclass.eq.4) then
        write(ifm,*) pgm,'TEXTE  : "'//cval(:ival)//'"'
    else if (iclass.eq.5) then
        write(ifm,*) pgm,'CMPLX  : (',rval(1),',',rval(2),')'
    else if (iclass.eq.6) then
        write(ifm,*) pgm,'BOOLEAN: ',ival
    else if (iclass.gt.6.and.iclass.lt.13) then
        write(ifm,*) pgm,iclass,'  : "'//cval(:ival)//'"'
    else if (iclass.eq.13) then
        write(ifm,*) pgm,'UNDEF  : "'//cval(:ival)//'"'
    else
        write(ifm,*) pgm,'CLASSE INDEFINIE ',iclass
    endif
end subroutine
